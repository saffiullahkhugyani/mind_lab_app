import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/features/dashboard/data/models/project_model.dart';
import 'package:mind_lab_app/features/dashboard/data/models/subscription_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectDetailsPage extends StatefulWidget {
  const ProjectDetailsPage({super.key});

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  late String userId;
  int projectId = 0;
  List<Subscription> subscriptionData = [];

  Future<List<Subscription>> _getSubscribeData(
      String? userId, int projectId) async {
    final supabase = Supabase.instance.client;
    final data = await supabase.from('subscription').select('*').match({
      'user_id': userId,
      'project_id': projectId,
    });
    if (data.isNotEmpty) {
      try {
        final project =
            data.map((json) => Subscription.formJson(json)).toList();

        subscriptionData = project;

        return project;
      } catch (e) {
        log(e.toString());
      }
    }
    throw Exception('Failed to load data');
  }

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
    }

    return imageLink;
  }

  @override
  void initState() {
    super.initState();
    if (projectId > 0) {
      _getSubscribeData(userId, projectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Projects;

    setState(() {
      projectId = args.id;
      userId = (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      print(projectId);
      print(userId);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Detail'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          children: [
            Image.asset(_projectImage(args.id)),
            const SizedBox(
              height: 20,
            ),
            Text(
              args.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              args.description,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final supabase = Supabase.instance.client;
                  final userId =
                      (context.read<AppUserCubit>().state as AppUserLoggedIn)
                          .user
                          .id;
                  final projectId = args.id;
                  List<Subscription> subscriptionData = [];
                  try {
                    subscriptionData =
                        await _getSubscribeData(userId, projectId);
                  } catch (e) {
                    log(e.toString());
                  }

                  if (subscriptionData.isEmpty) {
                    await supabase.from('subscription').insert({
                      'user_id': userId,
                      'project_id': projectId,
                      'subscription': 0
                    });

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Request for subscription submitted'),
                        ),
                      );
                    }
                  } else if (subscriptionData.first.subscriptionStatus == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Already requested for subscription'),
                      ),
                    );
                  } else if (subscriptionData.first.subscriptionStatus == 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Already subscribed to the project'),
                      ),
                    );
                  }
                },
                child: const Text('Subscribe'))
          ],
        ),
      ),
    );
  }
}
