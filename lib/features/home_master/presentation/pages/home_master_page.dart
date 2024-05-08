import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/features/home_master/presentation/cubit/home_master_cubit.dart';

class HomeMasterPage extends StatefulWidget {
  final HomeMasterCubit cubit;
  const HomeMasterPage({
    super.key,
    required this.cubit,
  });

  @override
  State<HomeMasterPage> createState() => _HomeMasterPageState();
}

class _HomeMasterPageState extends State<HomeMasterPage> {
  HomeMasterCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    cubit.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Master Page'),
      ),
      body: Center(
        child: BlocBuilder(
          bloc: cubit,
          builder: ((context, state) {
            state as HomeMasterState;
            String userName =
                (context.read<AppUserCubit>().state as AppUserLoggedIn)
                    .user
                    .name;

            String currentState = state.appUserCubit.state.toString();

            return Center(
              child: Text('$currentState  $userName'),
            );
          }),
        ),
      ),
    );
  }
}
