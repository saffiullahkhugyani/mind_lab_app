import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/project_list/domain/entities/projet_list_entity.dart';
import 'package:mind_lab_app/features/project_list/presentation/bloc/project_list_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/widgets/text_box.dart';

class ProjectDetailPage extends StatefulWidget {
  const ProjectDetailPage({super.key});

  @override
  State<ProjectDetailPage> createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  String _projectImage(int projectId) {
    String imageLink = '';

    switch (projectId) {
      case 1:
        imageLink = 'lib/assets/images/rashid_rover.png';
        break;
      case 2:
        imageLink = 'lib/assets/images/modish.png';
        break;
      case 3:
        imageLink = 'lib/assets/images/mecanum_car.png';
        break;
      case 4:
        imageLink = 'lib/assets/images/battle_bot.png';
        break;
      case 5:
        imageLink = 'lib/assets/images/airplane.png';
        break;
      case 6:
        imageLink = 'lib/assets/images/rocket.png';
        break;
      case 7:
        imageLink = 'lib/assets/icons/car.png';
    }

    return imageLink;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    final args =
        ModalRoute.of(context)!.settings.arguments as ProjectListEntity;
    var subscriptionStatus = -1;
    if (args.subscription.isNotEmpty) {
      subscriptionStatus = args.subscription.first.subscription!;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Detail Page'),
      ),
      body: BlocConsumer<ProjectListBloc, ProjectListState>(
        listener: (context, state) {
          if (state is ProjectListFailure) {
            showFlashBar(
              context,
              state.error,
              FlashBarAction.error,
            );
          } else {
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is ProjectListLoading) {
            return const Loader();
          }
          return ListView(
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.asset(width: 100, height: 100, _projectImage(args.id)),
              const SizedBox(
                height: 20,
              ),
              MyTextbox(text: args.name, sectionName: 'Project Name'),
              MyTextbox(text: args.description, sectionName: 'Project Details'),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: subscriptionStatus == -1
                      ? () {
                          context.read<ProjectListBloc>().add(
                                SubscriptionRequestEvent(
                                    userId: userId,
                                    projectId: args.id,
                                    subscriptionStatus: 0),
                              );
                        }
                      : subscriptionStatus == 1
                          ? null
                          : null,
                  child: Text(
                    subscriptionStatus == -1
                        ? 'Request for subscription'
                        : subscriptionStatus == 1
                            ? 'You have already subscribed to this project'
                            : 'request for subscription has been sent',
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
