import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/core/widgets/app_upgrader_dialog.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/project_bloc.dart';
import 'package:mind_lab_app/features/dashboard/presentation/widgets/card_item.dart';
import 'package:mind_lab_app/features/project_list/presentation/pages/project_list_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/pages/user_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/widgets/show_dialog.dart';

final listProjectImages = [
  {"id": 1, "image_asset": 'lib/assets/images/rashid_rover.png'},
  {"id": 2, "image_asset": 'lib/assets/images/modish.png'},
  {"id": 3, "image_asset": 'lib/assets/images/mecanum_car.png'},
  {"id": 4, "image_asset": 'lib/assets/images/battle_bot.png'},
  {"id": 5, "image_asset": 'lib/assets/images/airplane.png'},
  {"id": 6, "image_asset": 'lib/assets/images/rocket.png'},
  {"id": 7, "image_asset": 'lib/assets/icons/car.png'},
];

final listProjectIcons = [
  {"id": 1, "image_asset": 'lib/assets/icons/moon-rover.png'},
  {"id": 2, "image_asset": 'lib/assets/icons/robot.png'},
  {"id": 3, "image_asset": 'lib/assets/icons/car.png'},
  {"id": 4, "image_asset": 'lib/assets/icons/bot.png'},
  {"id": 5, "image_asset": 'lib/assets/icons/aircraft.png'},
  {"id": 6, "image_asset": 'lib/assets/images/rocket.png'},
];

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  final _upgrader = AppUpgrader(
    debugLogging: true,
    durationUntilAlertAgain: const Duration(
      hours: 3,
    ),
  );

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
        showFlashBar(
          context,
          "Logged out",
          FlashBarAction.info,
        );
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
  void initState() {
    super.initState();
    context.read<ProjectBloc>().add(ProjectFetchAllProjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserDetailPage(),
                ),
              );
            },
            icon: const Icon(
              IconlyLight.profile,
            ),
          ),
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
      body: AppUpgraderDialog(
        upgrader: _upgrader,
        child: BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) {
            if (state is ProjectFailure) {
              log(state.error);
              showFlashBar(
                context,
                'Error while loading subscribed projects!',
                FlashBarAction.error,
              );
            }
          },
          builder: (context, state) {
            if (state is ProjectLoading) {
              return const Loader();
            }

            if (state is ProjectDisplaySuccess) {
              return GridView.builder(
                padding: const EdgeInsets.only(top: 20),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: (MediaQuery.of(context).orientation ==
                            Orientation.portrait)
                        ? 2
                        : 3),
                itemCount: state.projectList.length,
                itemBuilder: (BuildContext context, index) {
                  final project = state.projectList[index];
                  final subscribedProjects = state.subscribedProjectList;
                  final imageAsset = listProjectImages
                      .firstWhere((element) => element['id'] == project.id);

                  final isSubscribed = subscribedProjects.any(
                      (subscribedProject) =>
                          subscribedProject.project.id == project.id);

                  return CardItem(
                      color: isSubscribed
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.1),
                      elevation: isSubscribed ? 2 : 0,
                      text: project.name,
                      image: imageAsset['image_asset'].toString(),
                      onTap: () {
                        if (isSubscribed) {
                          switch (project.id) {
                            case 1:
                              Navigator.pushNamed(context, roverMainPageRoute);
                              break;
                            case 7:
                              Navigator.pushNamed(context, arcadeGameOneRoute);
                              break;
                          }
                        } else {
                          // showFlushBar(context, 'Feature Coming soon',
                          //     FlushBarAction.info);
                          showFlashBar(context, "Feature Coming soon",
                              FlashBarAction.info);
                        }
                      });
                },
              );
            }

            return const Center(
              child: Text("To get access, Please subscribe to a project"),
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
              icon: const Icon(CupertinoIcons.add),
              heroTag: 'herotag3',
              onPressed: () {
                Navigator.pushNamed(context, modhishRoute);
              },
              label: const Text('modish')),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
              icon: const Icon(CupertinoIcons.add),
              heroTag: 'herotag1',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProjectListPage()));
              },
              label: const Text('Request Project')),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton.extended(
              icon: const Icon(CupertinoIcons.doc),
              heroTag: 'herotag2',
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => const ProjectListPage()));

                Navigator.pushNamed(context, addCertificateRoute);
              },
              label: const Text('Upload Certificate')),
        ],
      ),
    );
  }
}
