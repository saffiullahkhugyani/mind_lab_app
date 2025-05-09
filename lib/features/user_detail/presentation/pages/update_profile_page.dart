import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/user_detail/presentation/widgets/update_text_field.dart';
import '../../../../core/utils/pick_image.dart';
import '../bloc/update_profile_bloc/update_profile_bloc.dart';

class UpdataProfilePage extends StatefulWidget {
  const UpdataProfilePage({super.key});

  @override
  State<UpdataProfilePage> createState() => _UpdataProfilePageState();
}

class _UpdataProfilePageState extends State<UpdataProfilePage> {
  final nameUpdateController = TextEditingController();
  final dobUpdateController = TextEditingController();
  final numberUpdateController = TextEditingController();
  File? image;
  String? ageGroup;
  final formKey = GlobalKey<FormState>();

  final ageGroupListData = [
    'Under 6 years',
    '6-13 years',
    '14-18 years',
    '19-25 years',
    'Above 25 years'
  ];

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  // Future<void> _selectDate() async {
  //   DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (selectedDate != null) {
  //     setState(() {
  //       dobUpdateController.text = DateFormat('d-MM-yyy').format(selectedDate);
  //     });
  //   }
  // }

  void updateProfile() {
    if (nameUpdateController.text.trim().isNotEmpty ||
        numberUpdateController.text.trim().isNotEmpty ||
        dobUpdateController.text.trim().isNotEmpty ||
        image != null) {
      final userId =
          (context.read<AppStudentCubit>().state as AppStudentSelected)
              .student
              .id;

      context.read<UpdateProfileBloc>().add(UpdateUserProfileEvent(
          studentId: userId,
          name: nameUpdateController.text.trim(),
          number: numberUpdateController.text.trim(),
          dateOfBirth: ageGroup,
          imageFile: image));
    } else {
      showFlashBar(
        context,
        "Please provide a valid update",
        FlashBarAction.error,
      );
    }

    // if (formKey.currentState!.validate() && image != null) {
    //   final userId =
    //       (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

    //   context.read<UpdateProfileBloc>().add(UpdateUserProfileEvent(
    //       userId: userId,
    //       name: nameUpdateController.text.trim(),
    //       number: numberUpdateController.text.trim(),
    //       dateOfBirth: dobUpdateController.text.trim(),
    //       imageFile: image!));
    // } else {
    //   showSnackBar(context, "Please select all fields");
    // }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profile"),
      ),
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
        listener: (context, state) {
          if (state is UpdateProfileFailure) {
            showFlashBar(
              context,
              state.error,
              FlashBarAction.error,
            );
          }
          if (state is UpdateProfileSuccess) {
            showFlashBar(
              context,
              "Profile updated Successfully",
              FlashBarAction.success,
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is UpdateProfileLoading) {
            return const Loader();
          }
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            image != null
                                ? Container(
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
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
                                    width: 200,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
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
                            Positioned(
                              bottom: 10,
                              right: 10,
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
                      const SizedBox(
                        height: 30,
                      ),
                      UpdateTextField(
                        hintText: "Name",
                        controller: nameUpdateController,
                        iconData: Icons.person,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                            label: Text("Select age Group")),
                        items: ageGroupListData
                            .map<DropdownMenuItem<String>>(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                        validator: (value) {
                          if (value == null) {
                            return "Please select an age group";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          ageGroup = value;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      UpdateTextField(
                        hintText: "Number",
                        controller: numberUpdateController,
                        iconData: Icons.phone_android,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            updateProfile();
                          },
                          child: const Text("Update Profile"))
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
