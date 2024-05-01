import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/features/dashboard/data/models/subscription_model.dart';
import 'package:mind_lab_app/features/dashboard/presentation/widgets/card_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/models/subscription_user_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Subscription> subscribedProjects = [];

  final supabase = Supabase.instance.client;

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

  Future<List<Item>> _getSubscribedProjectDataAndUsers() async {
    final data = await supabase
        .from('subscription')
        .select('profiles(id, name), projects(id, name), subscription')
        .match({'user_id': supabase.auth.currentUser!.id, 'subscription': 1});

    if (data.isNotEmpty) {
      final subscriptionData = data.map((json) => Item.fromJson(json)).toList();
      return subscriptionData;
    }

    throw Exception('Failed to load request list');
  }

  Future<List<Subscription>> _getSubscribedProjectList() async {
    final List<dynamic> data =
        await supabase.from('subscription').select('*').match({
      'user_id': supabase.auth.currentUser!.id,
      'subscription': 1,
    });

    if (data.isNotEmpty) {
      try {
        final projectList =
            data.map((json) => Subscription.formJson(json)).toList();
        // log(projectList.toString());
        return projectList;
      } catch (e) {
        log(e.toString());
      }
    }

    throw Exception('Failed to load projects list');
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getSubscribedProjectDataAndUsers(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 2
                      : 3),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, index) {
                final projectData = snapshot.data![index];
                return CardItem(
                  text: projectData.project.name,
                  image: _projectImage(projectData.project.id),
                  onTap: () {
                    switch (projectData.project.id) {
                      case 1:
                        Navigator.pushNamed(context, roverMainPageRoute);
                        break;
                      case 2:
                        log('');
                        break;
                      case 3:
                        log('');
                        break;
                      case 4:
                        log('');
                        break;
                      case 5:
                        log('');
                        break;
                      case 6:
                        log('');
                        break;
                    }
                  },
                );
              });
        } else if (snapshot.hasError) {
          return const Center(
              child: Text(
            'Error, Try again later!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ));
        }

        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
