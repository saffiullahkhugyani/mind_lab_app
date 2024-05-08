import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/bluetooth/bluetooth_manager.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/constants/constants.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/providers/rashid_rover/command_list_provier.dart';
import 'package:mind_lab_app/core/theme/theme.dart';
import 'package:mind_lab_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mind_lab_app/features/auth/presentation/pages/login_page.dart';
import 'package:mind_lab_app/features/auth/presentation/pages/signup_page.dart';
import 'package:mind_lab_app/features/dashboard/presentation/pages/subscribe_project_page.dart';
import 'package:mind_lab_app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:mind_lab_app/features/dashboard/presentation/pages/home_page.dart';
import 'package:mind_lab_app/features/dashboard/presentation/pages/project_details_page.dart';
import 'package:mind_lab_app/features/bluetooth/bluetooth_page.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/pages/rover_controller_page.dart';
import 'package:mind_lab_app/features/rashid_rover/presentation/pages/rover_main_page.dart';
import 'package:mind_lab_app/init_dependencies.dart';
import 'package:provider/provider.dart';

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
        ChangeNotifierProvider(create: (context) => CommandList())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: AppTheme.lightThemeMode,
        routes: {
          loginRoute: (context) => const LoginPage(),
          registerRoute: (context) => const SignUpPage(),
          homePageRoute: (context) => const HomePage(),
          dashboardRoute: (context) => const DashboardPage(),
          roverMainPageRoute: (context) => const RoverMainPage(),
          roverControllerRoute: (context) => const RoverControllerPage(),
          bluetoothDevicesRoute: (context) => const BluetoothPage(),
          addProjectRoute: (context) => const AddPorjectpage(),
          projectDetailsRoute: (context) => const ProjectDetailsPage(),
        },
        home: BlocSelector<AppUserCubit, AppUserState, bool>(
          selector: (state) {
            return state is AppUserLoggedIn;
          },
          builder: (context, isLoggedIn) {
            if (isLoggedIn) {
              // return HomeMasterPage(
              //   cubit: serviceLocator(param1: const HomeMasterInitialParams()),
              // )
              return const HomePage();
            }
            return const LoginPage();
          },
        ),
      ),
    );
  }
}
