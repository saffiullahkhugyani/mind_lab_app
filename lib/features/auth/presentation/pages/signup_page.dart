import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/constants/country_list.dart';
import 'package:mind_lab_app/core/theme/theme_data.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mind_lab_app/features/auth/presentation/pages/login_page.dart';
import 'package:mind_lab_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:mind_lab_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:mind_lab_app/features/auth/presentation/widgets/privcy_policy.dart';
import 'package:mind_lab_app/features/auth/presentation/widgets/terms_and_condition.dart';

import '../../../../core/utils/pick_image.dart';
import '../../../../core/widgets/show_bottom_sheet.dart';

class SignUpPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpPage(),
      );
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final ageGroupListData = [
    'Under 6 years',
    '6-13 years',
    '14-18 years',
    'Above 18 years'
  ];

  final genderData = ['Not Specified', 'Male', 'Female'];

  final registerAs = {'Student': 4, 'Guardian': 6};

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final mobileController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? phoneNumber;
  String? gender;
  String? ageGroup;
  String? nationality;
  File? avatarImage;
  String? selectedRole;

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
    passwordController.dispose();
    nameController.dispose();
    ageController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void validateForm() {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      // Check individual fields
      List<String> emptyFields = [];

      if (nameController.text.isEmpty) emptyFields.add('Name');
      if (emailController.text.isEmpty) emptyFields.add('Email');
      if (passwordController.text.isEmpty) emptyFields.add('Password');
      if (ageGroup == null) emptyFields.add('Age Group');
      if (gender == null) emptyFields.add('Gender');
      if (nationality == null) emptyFields.add('Nationality');
      if (phoneNumber == null) emptyFields.add('Phone Number');
      if (selectedRole == null) emptyFields.add('Registration Type');

      showFlashBar(
        context,
        "Please fill: ${emptyFields.join(', ')}",
        FlashBarAction.error,
      );
      return;
    }

    // if (avatarImage == null) {
    //   showFlashBar(
    //     context,
    //     "Please select a profile image",
    //     FlashBarAction.error,
    //   );
    //   return;
    // }

    context.read<AuthBloc>().add(
          AuthSignUp(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
              name: nameController.text.trim(),
              ageGroup: ageGroup!,
              mobile: phoneNumber!,
              gender: gender!,
              imageFile: avatarImage,
              nationality: nationality!,
              roleId: registerAs[selectedRole]!),
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthFailure) {
                showFlashBar(
                  context,
                  state.message,
                  FlashBarAction.error,
                );
              } else if (state is AuthSuccess) {
                final roleId =
                    (context.read<AppUserCubit>().state as AppUserLoggedIn)
                        .user
                        .roleId;
                if (roleId == 6) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    parentRoute,
                    (route) => false,
                  );
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    dashboardRoute,
                    (route) => false,
                  );
                }
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: Loader());
              }
              return Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                        height: 100,
                        width: 100,
                        'lib/assets/app_icon/app_icon.png'),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Sign Up.',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                                    backgroundImage: FileImage(avatarImage!),
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
                    AuthField(
                      hintText: 'Name',
                      controller: nameController,
                      icon: Icons.person_2_outlined,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthField(
                        hintText: 'Email',
                        controller: emailController,
                        icon: Icons.email_outlined),
                    const SizedBox(
                      height: 15,
                    ),
                    AuthField(
                      hintText: 'Password',
                      controller: passwordController,
                      icon: Icons.lock_outline,
                      isObscureText: true,
                    ),
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
                      height: 15,
                    ),
                    IntlPhoneField(
                      initialCountryCode: 'AE',
                      controller: mobileController,
                      validator: (value) {
                        if (value!.number.toString().isEmpty) {
                          return "Enter a valid number";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        phoneNumber = value.completeNumber;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.app_registration),
                        labelText: "Select Registration type",
                      ),
                      items: registerAs.keys
                          .map<DropdownMenuItem<String>>(
                            (String key) => DropdownMenuItem(
                              value: key,
                              child: Text(key),
                            ),
                          )
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return "Please select your registration type";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        selectedRole = value;
                        int? selectedId = registerAs[selectedRole];
                        print("Selected Role ID: $selectedId ");
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: RichText(
                        text: TextSpan(
                            text: "By clicking sign up, you agree to our ",
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              TextSpan(
                                text: "Privacy Policy",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: darkBlueGrey,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    BottomSheets.yesAbortBottonSheet(
                                      const TermsAndCondition(),
                                      context,
                                    );
                                  },
                              ),
                              const TextSpan(
                                text: " and ",
                              ),
                              TextSpan(
                                text: "Terms and  Condition.",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: darkBlueGrey,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    BottomSheets.yesAbortBottonSheet(
                                        const PrivacyPolicy(), context);
                                    log("Terms and Condition clicked");
                                  },
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    AuthGradientButton(
                      buttonText: 'Sign Up',
                      onPressed: () {
                        validateForm();
                        // if (formKey.currentState!.validate() &&
                        //     avatarImage != null) {
                        //   context.read<AuthBloc>().add(
                        //         AuthSignUp(
                        //             email: emailController.text.trim(),
                        //             password: passwordController.text.trim(),
                        //             name: nameController.text.trim(),
                        //             ageGroup: ageGroup!,
                        //             mobile: phoneNumber!,
                        //             gender: gender!,
                        //             imageFile: avatarImage!,
                        //             nationality: nationality!,
                        //             roleId: registerAs[selectedRole]!),
                        //       );
                        // } else {
                        //   showFlashBar(
                        //     context,
                        //     "Please fill all the fields",
                        //     FlashBarAction.error,
                        //   );
                        // }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context, LoginPage.route(), (route) => false);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: darkBlueGrey,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
