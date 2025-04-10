import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/core/widgets/gradient_button.dart';
import 'package:mind_lab_app/core/widgets/input_field.dart';
import 'package:mind_lab_app/features/parent_child/presentation/bloc/parent_child_bloc/parent_child_bloc.dart';

class AddChildForm extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddChildForm(),
      );

  const AddChildForm({super.key});

  @override
  State<AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends State<AddChildForm> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  // final ageGroupController = TextEditingController();
  // final mobileController = TextEditingController();
  final studentIdController = TextEditingController();
  // final genderController = TextEditingController();
  // final nationalityController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? gender;
  String? ageGroup;
  String? nationality;
  File? avatarImage;
  bool isStudentFound = false;

  // void selectImage() async {
  //   final pickedImage = await pickImage();
  //   if (pickedImage != null) {
  //     setState(() {
  //       avatarImage = pickedImage;
  //     });
  //   }
  // }

  void searchStudent() async {
    final studentId = studentIdController.text.trim();
    if (studentId.isEmpty) {
      showFlashBar(
        context,
        'Please enter a valid student ID.',
        FlashBarAction.error,
      );

      return;
    }

    // Simulate fetching student details (replace with actual API call)
    // Example: Fetch student details from backend
    context.read<ParentChildBloc>().add(
          FetchStudentDetailsEvent(studentId: studentId),
        );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    // ageGroupController.dispose();
    // mobileController.dispose();
    // genderController.dispose();
    // nationalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Child'),
      ),
      body: BlocConsumer<ParentChildBloc, ParentChildState>(
        listener: (context, state) {
          if (state is ParentChildFailure) {
            showFlashBar(
              context,
              state.message,
              FlashBarAction.success,
            );
          } else if (state is ParentChildRequested) {
            showFlashBar(
              context,
              'Requested to add ${nameController.text} having email ${emailController.text} as a child',
              FlashBarAction.success,
            );
            Navigator.pop(context);
          } else if (state is StudentDetailsLoaded) {
            setState(() {
              nameController.text = state.studentEntity.name;
              emailController.text = state.studentEntity.email;
              // mobileController.text = state.studentEntity.number;
              // ageGroupController.text = state.studentEntity.ageGroup;
              // genderController.text = state.studentEntity.gender;
              // nationalityController.text = state.studentEntity.nationality;
              isStudentFound = true;
            });
          }
        },
        builder: (context, state) {
          if (state is ParentChildLoading) {
            // return Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Loader(),
            //     const SizedBox(
            //       height: 20,
            //     ),
            //     Text(
            //       'Loading...',
            //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //     ),
            //   ],
            // );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputField(
                    hintText: 'Student ID',
                    controller: studentIdController,
                    icon: Icons.school_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Student ID is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GradientButton(
                    buttonText: "Search Student",
                    onPressed: searchStudent,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InputField(
                    hintText: 'Name',
                    controller: nameController,
                    icon: Icons.person_2_outlined,
                    isEnabled: false,
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // InputField(
                  //   hintText: 'Email',
                  //   controller: emailController,
                  //   icon: Icons.email_outlined,
                  //   isEnabled: false,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Email is required';
                  //     }
                  //     if (!value.contains('@')) {
                  //       return 'Enter a valid email address';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // InputField(
                  //   hintText: 'Mobile Number',
                  //   controller: mobileController,
                  //   icon: Icons.phone_rounded,
                  //   isEnabled: false,
                  // ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // InputField(
                  //   hintText: 'Age Group',
                  //   controller: ageGroupController,
                  //   icon: Icons.calendar_today_outlined,
                  //   isEnabled: false,
                  // ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // InputField(
                  //   hintText: 'Gender',
                  //   controller: genderController,
                  //   icon: Icons.male,
                  //   isEnabled: false,
                  // ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // InputField(
                  //   hintText: 'Nationality',
                  //   controller: nationalityController,
                  //   icon: Icons.flag,
                  //   isEnabled: false,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  GradientButton(
                    buttonText: "Add Child",
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<ParentChildBloc>().add(
                              AddChildEvent(
                                  childId: studentIdController.text.trim()),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
