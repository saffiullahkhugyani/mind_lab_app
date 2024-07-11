import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/utils/pick_image.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
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
        Navigator.pushNamed(context, updateProfileRoute);
        break;
      case 1:
        Navigator.pushNamed(context, addCertificateRoute);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var userEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    return Scaffold(
      appBar: AppBar(title: const Text('User Details Page'), actions: [
        PopupMenuButton<int>(
            icon: const Icon(Icons.menu),
            onSelected: (item) => handleSelected(item),
            itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                      value: 0, child: Text("Update profile")),
                  const PopupMenuItem<int>(
                      value: 1, child: Text("Add a certificate")),
                ])
      ]),
      body: BlocConsumer<UserDetailBloc, UserDetailState>(
          listener: (context, state) {
        if (state is UserDetailFailure) {
          showSnackBar(context, state.error);
        }
      }, builder: (context, state) {
        if (state is UserDetailLoading) {
          return const Loader();
        }

        if (state is UserDetailDisplaySuccess) {
          var userDetail = state.userDetail.first;
          return ListView(
            children: [
              //profile picture

              const SizedBox(height: 50),
              Center(
                child: GestureDetector(
                  onTap: () {
                    selectImage();
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      image != null
                          ? Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
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
                                backgroundImage: FileImage(image!),
                              ),
                            )
                          : Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 4, color: Colors.white),
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ],
                                shape: BoxShape.circle,
                                image: const DecorationImage(
                                    fit: BoxFit.scaleDown,
                                    image: AssetImage(
                                        'lib/assets/images/no-user-image.png')),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                              ),
                              color: Colors.grey),
                          child: const Icon(Icons.edit),
                        ),
                      ),
                    ],
                  ),
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
                userDetail.name,
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text('My Details',
                    style: TextStyle(color: Colors.grey[600])),
              ),
              MyTextbox(text: userDetail.id, sectionName: 'User ID'),
              MyTextbox(
                text: userEmail,
                sectionName: 'User Email',
              ),
              MyTextbox(text: userDetail.age, sectionName: 'Age'),
              MyTextbox(text: userDetail.mobile, sectionName: 'Mobile'),
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
