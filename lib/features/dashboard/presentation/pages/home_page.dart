import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/bottom_nav_cubit.dart';
import 'package:mind_lab_app/features/dashboard/presentation/widgets/main_wrapper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: const MainWrapper(),
    );
  }
}
