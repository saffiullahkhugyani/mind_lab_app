import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/utils/pick_image.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/core/widgets/show_dialog.dart';
import 'package:mind_lab_app/features/auth/presentation/pages/login_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/user_detail_bloc/user_detail_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/widgets/text_box.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<UserDetailBloc>().add(UserDetailFetchUserDetail());
  }

  void handleSelected(int item) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, updateProfileRoute).then(
          (_) => setState(
            () {
              context.read<UserDetailBloc>().add(UserDetailFetchUserDetail());
            },
          ),
        );
        break;
      case 1:
        Navigator.pushNamed(context, addCertificateRoute);
        break;
      case 2:
        deleteAccount(context);
        break;
    }
  }

  Future<void> deleteAccount(BuildContext context) async {
    final action = await Dialogs.yesAbortDialog(
      context,
      "Delete Account",
      "Are you sure you want to delete you account? This action cannot be undone.",
      abortBtnText: "Cancel",
      yesButtonText: "Delete",
      icon: Icons.delete,
    );
    if (context.mounted) {
      _handleDeleteAccount(context, action);
    }
  }

  void _handleDeleteAccount(BuildContext context, DialogAction action) {
    if (action == DialogAction.yes) {
      context.read<UserDetailBloc>().add(UserDeleteAccount());
    }
  }

  @override
  Widget build(BuildContext context) {
    var userEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          PopupMenuButton<int>(
              icon: const Icon(Icons.menu),
              onSelected: (item) => handleSelected(item),
              itemBuilder: (context) => [
                    const PopupMenuItem<int>(
                        value: 0, child: Text("Update profile")),
                    const PopupMenuItem<int>(
                        value: 1, child: Text("Add a certificate")),
                    const PopupMenuItem<int>(
                        value: 2, child: Text("Delete account")),
                  ])
        ],
      ),
      body: BlocConsumer<UserDetailBloc, UserDetailState>(
          listener: (context, state) {
        if (state is UserDetailFailure) {
          showSnackBar(context, state.error);
        }

        if (state is UserDeleteAccountFailure) {
          showSnackBar(context, state.errorMessage);
        }

        if (state is UserDeleteAccountSuccess) {
          showSnackBar(context, state.successMessage);
          Navigator.of(context)
              .pushAndRemoveUntil(LoginPage.route(), (route) => false);
        }
      }, builder: (context, state) {
        if (state is UserDetailLoading) {
          return const Loader();
        }

        if (state is UserDetailDisplaySuccess) {
          final userInfo = state.userDetail.userDetails.first;
          final userCertificates = state.userDetail.certificates;
          return ListView(
            children: [
              //profile picture

              const SizedBox(height: 50),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    userInfo.imageUrl.isNotEmpty
                        ? Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(userInfo.imageUrl),
                            ),
                          )
                        : Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(width: 4, color: Colors.white),
                              boxShadow: [
                                BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ],
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: AssetImage(
                                      'lib/assets/images/no-user-image.png')),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                userInfo.name,
              ),
              const SizedBox(height: 50),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text(
                        'My Details',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MyTextbox(text: userInfo.id, sectionName: 'User ID'),
                    MyTextbox(
                      text: userEmail,
                      sectionName: 'User Email',
                    ),
                    MyTextbox(text: userInfo.age, sectionName: 'Age Group'),
                    MyTextbox(text: userInfo.mobile, sectionName: 'Mobile'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 10, bottom: 10),
                      child: Text(' My Certificates',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                    userCertificates.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: userCertificates.length,
                            itemBuilder: (context, index) {
                              final certificate = userCertificates[index];
                              return Card(
                                child: ListTile(
                                  title: Text(certificate.skill.name),
                                  leading: CircleAvatar(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  trailing: const Icon(Icons.description),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, top: 10.0),
                            child: Text('No certificates added yet.',
                                style: TextStyle(color: Colors.grey[600])),
                          ),
                  ],
                ),
              ),
            ],
          );
        }

        return const Center(
            child: Text(
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                'User Details not available'));
      }),
    );
  }
}
