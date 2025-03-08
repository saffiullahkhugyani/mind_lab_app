import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/country_list.dart';
import 'package:mind_lab_app/core/utils/pick_image.dart';
import 'package:mind_lab_app/core/widgets/gradient_button.dart';
import 'package:mind_lab_app/core/widgets/input_field.dart';
import 'package:mind_lab_app/features/parent_child/presentation/bloc/parent_child_bloc.dart';

class AddChildForm extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddChildForm(),
      );

  const AddChildForm({super.key});

  @override
  State<AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends State<AddChildForm> {
  final ageGroupListData = [
    'Under 6 years',
    '6-13 years',
    '14-18 years',
    '19-25 years',
    'Above 25 years'
  ];

  final genderData = ['Male', 'Female'];

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? gender;
  String? ageGroup;
  String? nationality;
  File? avatarImage;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        avatarImage = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    ageController.dispose();
    mobileController.dispose();
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          } else if (state is ParentChildSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Child added successfully'),
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is ParentChildLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        avatarImage != null
                            ? Container(
                                width: 200,
                                height: 200,
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
                                  backgroundImage: FileImage(avatarImage!),
                                ),
                              )
                            : Container(
                                width: 200,
                                height: 200,
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
                  InputField(
                    hintText: 'Name',
                    controller: nameController,
                    icon: Icons.person_2_outlined,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InputField(
                      hintText: 'Email',
                      controller: emailController,
                      icon: Icons.email_outlined),
                  const SizedBox(
                    height: 15,
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
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.male),
                        label: Text("Select a gender")),
                    items: genderData
                        .map<DropdownMenuItem<String>>(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Please select your gender";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      gender = value;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.flag),
                        label: Text("Select nationality")),
                    items: countryList
                        .map<DropdownMenuItem<String>>(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return "Please select your nationality";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      nationality = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GradientButton(
                    buttonText: "Add Child",
                    onPressed: () {
                      if (formKey.currentState!.validate() &&
                          avatarImage != null) {
                        context.read<ParentChildBloc>().add(
                              AddChildEvent(
                                email: emailController.text.trim(),
                                name: nameController.text.trim(),
                                ageGroup: ageGroup!,
                                gender: gender!,
                                nationality: nationality!,
                                imageFile: avatarImage!,
                              ),
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
