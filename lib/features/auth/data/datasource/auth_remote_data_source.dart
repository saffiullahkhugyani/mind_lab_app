import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:mind_lab_app/core/errors/exceptions.dart';
import 'package:mind_lab_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:crypto/crypto.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String ageGroup,
    required String mobile,
    required String gender,
    required String nationality,
    required int roleId,
  });

  Future<String> uploadUserImage({
    required File imageFile,
    required UserModel userModel,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();

  Future<UserModel> loginWithGoogle();

  Future<UserModel> loginWithApple();

  Future<UserModel> uploadStudentDetails({
    required String userId,
    required String name,
    required String email,
    required String ageGroup,
    required String mobile,
    required String gender,
    required String nationality,
    required String imageUrl,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw const ServerException('User is null');
      }

      // Extracting the id from the response and merging it with userMetadata
      final userMetadata = response.user!.userMetadata!;
      userMetadata['id'] = response.user!.id;

      log(response.user.toString());
      return UserModel.fromJson(
        userMetadata,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
    required String ageGroup,
    required String mobile,
    required String gender,
    required String nationality,
    required int roleId,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
          'age': ageGroup,
          'email': email,
          'mobile': mobile,
          'gender': gender,
          'nationality': nationality,
          'role_id': roleId,
        },
      );
      if (response.user == null) {
        throw const ServerException('User is null');
      }

      // Extracting the id from the response and merging it with userMetadata
      final userMetadata = response.user!.userMetadata!;
      userMetadata['id'] = response.user!.id;

      return UserModel.fromJson(
        userMetadata,
      );
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadUserImage({
    required File imageFile,
    required UserModel userModel,
  }) async {
    try {
      final path = '${userModel.id}/${userModel.id}-image';

      await supabaseClient.storage
          .from('profile-images')
          .upload(path, imageFile);

      final imageUrl =
          supabaseClient.storage.from('profile-images').getPublicUrl(path);
      await supabaseClient
          .from('profiles')
          .update({"profile_image_url": imageUrl}).eq('id', userModel.id);

      return imageUrl;
    } on StorageException catch (e) {
      throw (ServerException(e.message));
    } catch (e) {
      throw (ServerException(e.toString()));
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );

        return UserModel.fromJson(userData.first)
            .copyWith(email: currentUserSession!.user.email);
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      const webClientId =
          "719773290057-4frsk845o9irfsq228kjtrni8f26att6.apps.googleusercontent.com";
      const iosClientId =
          "719773290057-hnjtcffh05fqfuu9p9ipe86prosruck2.apps.googleusercontent.com";

      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw const ServerException("No Access Token found");
      }

      if (idToken == null) {
        throw const ServerException("No ID Token found");
      }

      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return UserModel.fromJson(response.user!.userMetadata!);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithApple() async {
    try {
      final rawNonce = supabaseClient.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ],
        nonce: hashedNonce,
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw const ServerException("No Id token found.");
      }

      final response = await supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );

      // check if user data is available (only on first login)
      final userId = response.user?.id;

      // prepare user data for upsert
      final userData = {
        "id": userId,
        "email": credential.email ?? response.user?.email,
      };

      // Only include the name if this is the first time Apple is providing it
      if (credential.givenName != null && credential.familyName != null) {
        userData["name"] = "${credential.givenName} ${credential.familyName}";
      }

      //upsert user data into the profiles table
      await supabaseClient.from('profiles').upsert(userData).eq('id', userId!);

      // Get the user metadata from the response and modify the name
      final userMetadata = response.user!.userMetadata!;

      // Modify the name in the userMetadata (if needed)
      if (credential.givenName != null && credential.familyName != null) {
        userMetadata['name'] =
            "${credential.givenName} ${credential.familyName}";
      } else {
        final userName = await supabaseClient
            .from('profiles')
            .select('name')
            .eq('id', userId);
        userMetadata['name'] = "${userName.first['name']}";
      }

      return UserModel.fromJson(userMetadata);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> uploadStudentDetails({
    required String userId,
    required String name,
    required String email,
    required String ageGroup,
    required String mobile,
    required String gender,
    required String nationality,
    required String imageUrl,
  }) async {
    try {
      final studentData = {
        'profile_id': userId,
        'name': name,
        'age_group': ageGroup,
        'email': email,
        'mobile': mobile,
        'gender': gender,
        'nationality': nationality,
        'image_url': imageUrl,
      };

      final response =
          await supabaseClient.from('students').insert(studentData).select();

      return UserModel.fromJson(response.first);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      log(e.toString());
      throw ServerException(e.toString());
    }
  }
}
