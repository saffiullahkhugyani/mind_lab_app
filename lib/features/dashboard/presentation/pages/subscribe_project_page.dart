import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/features/dashboard/data/models/project_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPorjectpage extends StatefulWidget {
  const AddPorjectpage({super.key});

  @override
  State<AddPorjectpage> createState() => _AddPorjectpageState();
}

class _AddPorjectpageState extends State<AddPorjectpage> {
  Future<List<Projects>> _getProjectList() async {
    final supabase = Supabase.instance.client;
    final List<dynamic> data = await supabase.from('projects').select('*');

    if (data.isNotEmpty) {
      try {
        final projectList =
            data.map((json) => Projects.formJson(json)).toList();

        return projectList;
      } catch (e) {
        log(e.toString());
      }
    }

    throw Exception('Failed to load projects list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project List'),
      ),
      body: FutureBuilder<List<Projects>>(
        future: _getProjectList(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, index) {
                  final project = snapshot.data![index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: const Icon(CupertinoIcons.add_circled),
                      title: Text(
                        project.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        project.description,
                        maxLines: 2,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(projectDetailsRoute, arguments: project);
                      },
                      trailing: const Icon(Icons.arrow_right),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}
