import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/user_detail_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/widgets/text_box.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserDetailBloc>().add(UserDetailFetchUserDetail());
  }

  @override
  Widget build(BuildContext context) {
    var userEmail =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details Page'),
      ),
      body: BlocConsumer<UserDetailBloc, UserDetailState>(
          listener: (context, state) {
        if (state is UserDetailFailure) {
          showSnackBar(context, state.error);
        }
      }, builder: (context, state) {
        if (state is UserDetailLoading) {
          return const Loader();
        }

        if (state is UserDetailDisplaySuccess) {
          var userDetail = state.userDetail.first;
          return ListView(
            children: [
              //profile picture
              const SizedBox(height: 50),
              const Icon(size: 72, Icons.person),
              const SizedBox(
                height: 10,
              ),
              Text(
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
                userEmail,
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Text('My Details',
                    style: TextStyle(color: Colors.grey[600])),
              ),
              MyTextbox(text: userDetail.id, sectionName: 'User ID'),
              MyTextbox(
                text: userDetail.name,
                sectionName: 'User Name',
              ),
              MyTextbox(text: userDetail.age, sectionName: 'Age'),
              MyTextbox(text: userDetail.mobile, sectionName: 'Mobile'),
            ],
          );
        }

        return const Center(
            child: Text(
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                'User Details not available'));
      }),
    );
  }
}
