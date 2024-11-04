import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/bluetooth/bluetooth_manager.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/constants/constants.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/flutter_blue_plus/flutter_blue_plus_manager.dart';
import 'package:mind_lab_app/core/providers/credential_manager/user_credentials_provider.dart';
import 'package:mind_lab_app/core/providers/rashid_rover/command_list_provier.dart';
import 'package:mind_lab_app/core/theme/theme.dart';
import 'package:mind_lab_app/core/widgets/app_upgrader_dialog.dart';
import 'package:mind_lab_app/features/arcage_game_one/presentation/pages/arcade_game_one_page.dart';
import 'package:mind_lab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mind_lab_app/features/auth/presentation/pages/login_page.dart';
import 'package:mind_lab_app/features/auth/presentation/pages/signup_page.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/project_bloc.dart';
import 'package:mind_lab_app/features/dashboard/presentation/pages/project_page.dart';
import 'package:mind_lab_app/features/bluetooth/bluetooth_page.dart';
import 'package:mind_lab_app/features/flutter_blue_plus/presentation/pages/bluetooth_plus_page.dart';
import 'package:mind_lab_app/features/project_list/presentation/bloc/project_list_bloc.dart';
import 'package:mind_lab_app/features/project_list/presentation/pages/project_detail_page.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/pages/rover_controller_page.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/pages/rover_main_page.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/pages/step_duration_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/register_player_bloc/register_player_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/user_detail_bloc/user_detail_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/pages/add_certificate_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/pages/player_registration_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/pages/update_profile_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/pages/user_rank_page.dart';
import 'package:mind_lab_app/init_dependencies.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'features/user_detail/presentation/bloc/update_profile_bloc/update_profile_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ProjectBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<ProjectListBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<UserDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AddCertificateBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<UpdateProfileBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<RegisterPlayerBloc>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _upgrader = Upgrader(
      debugLogging: true, durationUntilAlertAgain: const Duration(hours: 3));

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BluetoothManager()),
        ChangeNotifierProvider(create: (context) => CommandList()),
        ChangeNotifierProvider(create: (context) => FlutterBluetoothPlus()),
        ChangeNotifierProvider(create: (context) => UserCredentials()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: AppTheme.lightThemeMode,
        routes: {
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const SignUpPage(),
          roverMainPageRoute: (context) => const RoverMainPage(),
          roverControllerRoute: (context) => const RoverControllerPage(),
          bluetoothDevicesRoute: (context) => const BluetoothPage(),
          projectDetailRoute: (context) => const ProjectDetailPage(),
          flutterBluePlusRoute: (context) => const BluetoothPlusPage(),
          stepDurationRoute: (context) => const StepDurationPage(),
          addCertificateRoute: (context) => const AddCertificate(),
          updateProfileRoute: (context) => const UpdataProfilePage(),
          arcadeGameOneRoute: (context) => const ArcadeGameOnePage(),
          userRankRoute: (context) => const UserRankPage(),
          playerRegistrationRoute: (context) => const PlayerRegistrationPage(),
        },
        home: AppUpgraderDialog(
          shouldPopScope: () => false,
          upgrader: _upgrader,
          child: BlocSelector<AppUserCubit, AppUserState, bool>(
            selector: (state) {
              log("Bloc selector: $state");
              return state is AppUserLoggedIn;
            },
            builder: (context, isLoggedIn) {
              if (isLoggedIn) {
                return const ProjectPage();
              }
              return const LoginPage();
            },
          ),
        ),
      ),
    );
  }
}
