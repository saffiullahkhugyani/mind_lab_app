import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mind_lab_app/core/widgets/gradient_button.dart';

import '../../../../core/common/cubits/app_user/app_user_cubit.dart';
import '../../../../core/common/entities/user.dart';
import '../../../../core/constants/country_list.dart';
import '../../../../core/constants/routes.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/widgets/loader.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/auth_field.dart';

class InfoFormPage extends StatefulWidget {
  const InfoFormPage({super.key});

  @override
  State<InfoFormPage> createState() => _InfoFormPageState();
}

class _InfoFormPageState extends State<InfoFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();

  String? _phoneNumber;
  String? _gender;
  String? _ageGroup;
  String? _nationality;
  String? _selectedRole;

  String? userId;

  User? _user;

  final List<String> _ageGroups = [
    'Under 6 years',
    '6-13 years',
    '14-18 years',
    'Above 18 years',
  ];

  final List<String> _genders = ['Not Specified', 'Male', 'Female'];

  final Map<String, int> _registrationTypes = {
    'Student': 4,
    'Guardian': 6,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is User) {
      _user = args;
      _setUserData(_user!);
    } else {
      debugPrint("❗User was not passed to InfoFormPage.");
    }
  }

  void _setUserData(User user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
  }

  void _handleSubmit() {
    bool isValid = _formKey.currentState!.validate();
    if (!isValid) {
      // Check individual fields
      List<String> emptyFields = [];

      if (_nameController.text.isEmpty) emptyFields.add('Name');
      if (_emailController.text.isEmpty) emptyFields.add('Email');
      if (_ageGroup == null) emptyFields.add('Age Group');
      if (_gender == null) emptyFields.add('Gender');
      if (_nationality == null) emptyFields.add('Nationality');
      if (_phoneNumber == null) emptyFields.add('Phone Number');
      if (_selectedRole == null) emptyFields.add('Registration Type');

      showFlashBar(
        context,
        "Please fill: ${emptyFields.join(', ')}",
        FlashBarAction.error,
      );
      return;
    }

    context.read<AuthBloc>().add(
          AuthUpdateUserInfo(
            id: userId!,
            email: _emailController.text.trim(),
            name: _nameController.text.trim(),
            ageGroup: _ageGroup!,
            mobile: _phoneNumber!,
            gender: _gender!,
            nationality: _nationality!,
            roleId: _registrationTypes[_selectedRole!]!,
          ),
        );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildRegistrationDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.app_registration),
        labelText: "Select Registration type",
      ),
      items: _registrationTypes.keys
          .map((key) => DropdownMenuItem(value: key, child: Text(key)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedRole = value;
        });
        debugPrint("Selected Role ID: ${_registrationTypes[value]}");
      },
      validator: (value) =>
          value == null ? "Please select your registration type" : null,
    );
  }

  @override
  void initState() {
    userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete your profile')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    const Text(
                      'Please fill in the following information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    AuthField(
                      hintText: 'Name',
                      controller: _nameController,
                      icon: Icons.person_2_outlined,
                    ),
                    const SizedBox(height: 15),
                    AuthField(
                      hintText: 'Email',
                      controller: _emailController,
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 15),
                    _buildDropdown(
                      label: "Select age group",
                      icon: Icons.calendar_today_outlined,
                      items: _ageGroups,
                      onChanged: (val) => _ageGroup = val,
                      validator: (val) =>
                          val == null ? "Please select an age group" : null,
                    ),
                    const SizedBox(height: 15),
                    _buildDropdown(
                      label: "Select a gender",
                      icon: Icons.male,
                      items: _genders,
                      onChanged: (val) => _gender = val,
                      validator: (val) =>
                          val == null ? "Please select your gender" : null,
                    ),
                    const SizedBox(height: 15),
                    IntlPhoneField(
                      initialCountryCode: 'AE',
                      controller: _mobileController,
                      validator: (value) => value?.number.isEmpty ?? true
                          ? "Enter a valid number"
                          : null,
                      onChanged: (value) => _phoneNumber = value.completeNumber,
                    ),
                    const SizedBox(height: 15),
                    _buildDropdown(
                      label: "Select nationality",
                      icon: Icons.flag,
                      items: countryList,
                      onChanged: (val) => _nationality = val,
                      validator: (val) =>
                          val == null ? "Please select your nationality" : null,
                    ),
                    const SizedBox(height: 15),
                    _buildRegistrationDropdown(),
                    const SizedBox(height: 20),
                    GradientButton(
                        buttonText: "Submit",
                        onPressed: () {
                          _handleSubmit();
                        }),
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
