import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/providers/credential_manager/user_credentials_provider.dart';
import 'package:mind_lab_app/core/theme/theme_data.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mind_lab_app/features/auth/presentation/pages/signup_page.dart';
import 'package:mind_lab_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:mind_lab_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:mind_lab_app/features/dashboard/presentation/pages/project_page.dart';
import 'package:mind_lab_app/features/parent_child/presentation/pages/parent_page.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../widgets/social_login_button.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool rememeberMe = false;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();

    // fetching if value exist in shared preference
    final notifier = Provider.of<UserCredentials>(context, listen: false);
    notifier.addListener(_updatedControllers);
    _updatedControllers();
  }

  void _updatedControllers() {
    final notifier = Provider.of<UserCredentials>(context, listen: false);
    if (notifier.email.isNotEmpty) {
      emailController.text = notifier.email;
    }

    if (notifier.password.isNotEmpty) {
      passwordController.text = notifier.password;
    }
  }

  void saveEmailAndPassword() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final notifier = Provider.of<UserCredentials>(context, listen: false);
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      await notifier.updateUserEmail(email);
      await notifier.updateUserPassword(password);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailure) {
                  showFlashBar(
                    context,
                    state.message,
                    FlashBarAction.error,
                  );
                } else if (state is AuthUserNotLoggedIn) {
                  // showFlashBar(
                  //   context,
                  //   state.message,
                  //   FlashBarAction.info,
                  // );
                } else if (state is AuthSuccess) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const ParentPage()),
                      (route) => false);
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
                        'Sign In',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AuthField(
                        hintText: 'Email',
                        controller: emailController,
                        icon: Icons.email,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      AuthField(
                        hintText: 'Password',
                        controller: passwordController,
                        icon: Icons.lock,
                        sufixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: hidePassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                        isObscureText: hidePassword,
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: rememeberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememeberMe = !rememeberMe;
                                });
                              }),
                          const Text("Remember me")
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthGradientButton(
                        buttonText: 'Sign In',
                        onPressed: () {
                          if (rememeberMe) {
                            saveEmailAndPassword();
                          }
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  AuthLogin(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            SignUpPage.route(),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Dont\' have an account? ',
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: 'Sign Up',
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
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      // or continue with
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Or continue with',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialLoginButton(
                              onTap: () {
                                context
                                    .read<AuthBloc>()
                                    .add(AuthLoginWithGoogle());
                              },
                              imagePath: 'lib/assets/social_logos/google.png'),
                          if (Platform.isIOS) ...[
                            const SizedBox(
                              width: 25,
                            ),
                            SocialLoginButton(
                                onTap: () {
                                  context
                                      .read<AuthBloc>()
                                      .add(AuthLoginWithApple());
                                },
                                imagePath: 'lib/assets/social_logos/apple.png'),
                          ]
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
