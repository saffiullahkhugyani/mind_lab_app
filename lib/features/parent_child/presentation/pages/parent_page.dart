import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/widgets/card_item.dart';
import 'package:mind_lab_app/features/parent_child/presentation/bloc/parent_child_bloc.dart';
import 'package:mind_lab_app/features/parent_child/presentation/pages/add_child_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/routes.dart';
import '../../../../core/utils/show_snackbar.dart';
import '../../../../core/widgets/loader.dart';
import '../../../../core/widgets/show_dialog.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final parentId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    setState(() {
      context.read<ParentChildBloc>().add(GetChildrenEvent(parentId: parentId));
    });
  }

  Future<void> _siOutDialog(BuildContext context) async {
    final action = await Dialogs.yesAbortDialog(
      context,
      "Sign out",
      "Are you sure you want to Sign out you account?",
      abortBtnText: "Cancel",
      yesButtonText: "Sign out",
      icon: Icons.logout,
    );
    if (context.mounted) {
      _signOut(action);
    }
  }

  Future<void> _signOut(DialogAction dialogAction) async {
    if (dialogAction == DialogAction.yes) {
      try {
        final supabase = Supabase.instance.client;
        await supabase.auth.signOut();
        await GoogleSignIn().signOut();
        // showFlashBar(
        //   context,
        //   "Logged out",
        //   FlashBarAction.info,
        // );
      } on AuthException catch (error) {
        showFlashBar(
          context,
          error.message,
          FlashBarAction.error,
        );
      } catch (error) {
        showFlashBar(
          context,
          error.toString(),
          FlashBarAction.error,
        );
      } finally {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(loginRoute);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Screen'),
        actions: [
          IconButton(
            onPressed: () {
              _siOutDialog(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final parentId =
              (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
          setState(() {
            context
                .read<ParentChildBloc>()
                .add(GetChildrenEvent(parentId: parentId));
          });
        },
        child: BlocConsumer<ParentChildBloc, ParentChildState>(
          listener: (context, state) {
            if (state is ParentChildFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ParentChildLoading) {
              return const Loader();
            }

            if (state is ParentChildSuccess) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                ),
                itemCount: state.children.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.children.length) {
                    return CardItem(
                      text: 'Add a child',
                      color: Colors.grey.withValues(alpha: 0.3),
                      elevation: 2,
                      isAddCard: true,
                      onTap: () async {
                        await Navigator.of(context).push(
                          AddChildForm.route(),
                        );
                        // .then((_) => context
                        //     .read<ParentChildBloc>()
                        //     .add(GetChildrenEvent()));
                        fetchData();
                      },
                    );
                  }

                  final child = state.children[index];
                  return CardItem(
                    text: child.name,
                    color: Colors.grey.withValues(alpha: 0.3),
                    isAddCard: false,
                    elevation: 2,
                    onTap: () {
                      context.read<AppStudentCubit>().updateStudent(child);
                      Navigator.of(context).pushNamed(dashboardRoute);
                    },
                  );
                },
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No children found"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
