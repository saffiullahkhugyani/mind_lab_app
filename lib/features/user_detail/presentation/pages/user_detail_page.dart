import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/utils/pick_image.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/core/widgets/show_dialog.dart';
import 'package:mind_lab_app/features/auth/presentation/pages/login_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/user_detail_bloc/user_detail_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/widgets/image_builder_widget.dart';
import 'package:mind_lab_app/features/user_detail/presentation/widgets/pie_chart.dart';
import 'package:mind_lab_app/features/user_detail/presentation/widgets/text_box.dart';
import 'package:crypto/crypto.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  File? image;
  String? parentId;
  String? studentId;
  int? roleId;

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

    // getting stored roleId
    roleId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.roleId;
    parentId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    studentId = (context.read<AppStudentCubit>().state as AppStudentSelected)
        .student
        .id;

    log("parentID: $parentId");
    log("studentID: $studentId");

    // fetching student data
    context.read<UserDetailBloc>().add(UserDetailFetchUserDetail(
          parentId: parentId!,
          studentId: studentId!,
          roleId: roleId!,
        ));
  }

  void handleSelected(int item) {
    switch (item) {
      case 0:
        Navigator.pushNamed(context, updateProfileRoute).then(
          (_) => setState(
            () {
              context.read<UserDetailBloc>().add(UserDetailFetchUserDetail(
                    parentId: parentId!,
                    studentId: studentId!,
                    roleId: roleId!,
                  ));
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

  // to get the player Id
  String generateShortUUID(String id) {
    var uuid = id; // Generate a standard UUID
    var bytes = utf8.encode(uuid); // Convert it to bytes
    var hash = sha256.convert(bytes); // Create a SHA-256 hash
    return hash.toString().substring(0, 5); // Return the first 8 characters
  }

  @override
  Widget build(BuildContext context) {
    // var userEmail =
    //     (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, notificationsRoute);
              },
              icon: Badge(
                isLabelVisible: true,
                offset: const Offset(8, 8),
                backgroundColor: Theme.of(context).colorScheme.error,
                child: const Icon(
                  Icons.notifications_outlined,
                ),
              )),
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
          showFlashBar(
            context,
            state.error,
            FlashBarAction.error,
          );
        }

        if (state is UserDeleteAccountFailure) {
          showFlashBar(context, state.errorMessage, FlashBarAction.error);
        }

        if (state is UserDeleteAccountSuccess) {
          showFlashBar(
            context,
            state.successMessage,
            FlashBarAction.success,
          );
          Navigator.of(context)
              .pushAndRemoveUntil(LoginPage.route(), (route) => false);
        }
      }, builder: (context, state) {
        if (state is UserDetailLoading) {
          return const Loader();
        }

        if (state is UserDetailDisplaySuccess) {
          final userInfo = state.userDetail.studentDetails.first;
          final userCertificates = state.userDetail.certificates;
          final certificateMaster = state.userDetail.certificateMasterList;
          final playerRegistration = state.userDetail.playerRegistration;
          log("player registration: ${state.userDetail.playerRegistration}");

          // log(playerRegistration.toString());
          return ListView(
            children: [
              //profile picture

              const SizedBox(height: 50),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    userInfo.imageUrl!.isNotEmpty
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
                              backgroundImage: NetworkImage(userInfo.imageUrl!),
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
              const SizedBox(
                height: 10,
              ),
              playerRegistration.isEmpty
                  ? Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(playerRegistrationRoute,
                                  arguments: userInfo)
                              .then(
                                (_) => setState(
                                  () {
                                    context.read<UserDetailBloc>().add(
                                          UserDetailFetchUserDetail(
                                            parentId: parentId!,
                                            studentId: studentId!,
                                            roleId: roleId!,
                                          ),
                                        );
                                  },
                                ),
                              );
                        },
                        child: const Text("Player registration"),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          elevation: 3,
                          child: ListTile(
                            dense: true,
                            tileColor: Colors.grey.shade200,
                            leading: CircleAvatar(child: Icon(Icons.menu)),
                            trailing: Icon(Icons.navigate_next),
                            title: const Text("My Rank"),
                            onTap: () {
                              Navigator.of(context).pushNamed(playerRankRoute,
                                  arguments: userInfo);
                            },
                          ),
                        ),
                      ),
                    ),
              certificateMaster.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          // decoration: BoxDecoration(
                          //   color: Colors.grey[400],
                          //   borderRadius: BorderRadius.circular(8),
                          //   boxShadow: [
                          //     BoxShadow(
                          //       color: Colors.black.withOpacity(
                          //           0.2), // Shadow color with opacity
                          //       spreadRadius: 2, // Spread radius
                          //       blurRadius: 6, // Blur radius
                          //       offset: const Offset(
                          //           0, 3), // Offset in the X and Y direction
                          //     ),
                          //   ],
                          // ),
                          // padding: const EdgeInsets.all(15),
                          // margin: const EdgeInsets.only(
                          //     left: 20, right: 20, top: 20),
                          child: Column(
                            children: [
                              Text(
                                "Asserted Certificates",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Piechart(certificateMaster: certificateMaster),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    )
                  : const SizedBox(height: 50),
              Column(
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
                  MyTextbox(text: userInfo.id, sectionName: 'Student ID'),
                  MyTextbox(
                    text: userInfo.email,
                    sectionName: 'User Email',
                  ),
                  MyTextbox(text: userInfo.ageGroup, sectionName: 'Age Group'),
                  MyTextbox(text: userInfo.number, sectionName: 'Mobile'),
                  MyTextbox(
                      text: userInfo.nationality, sectionName: 'Nationality'),
                ],
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
                                child: ExpansionTile(
                                  title: Text(certificate.certificateName),
                                  leading: CircleAvatar(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  trailing: const Icon(Icons.description),
                                  children: [
                                    ClipRRect(
                                      child: ImageBuilderWidget(
                                          imageUrl:
                                              certificate.certificateImageUrl),
                                    )
                                  ],
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
