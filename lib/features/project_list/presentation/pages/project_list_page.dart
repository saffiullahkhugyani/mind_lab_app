import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/project_list/presentation/bloc/project_list_bloc.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  @override
  void initState() {
    super.initState();

    context
        .read<ProjectListBloc>()
        .add(ProjectListFetechAllAvailableProjects());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project List Page'),
      ),
      body: BlocConsumer<ProjectListBloc, ProjectListState>(
        listener: (context, state) {
          if (state is ProjectListFailure) {
            showFlashBar(
              context,
              'No internet connection',
              FlashBarAction.error,
            );
          } else if (state is ProjectSubscriptionSuccess) {
            showFlashBar(
              context,
              'Request for project Subscription sended.',
              FlashBarAction.success,
            );
            setState(() {
              context
                  .read<ProjectListBloc>()
                  .add(ProjectListFetechAllAvailableProjects());
            });
          }
        },
        builder: (context, state) {
          if (state is ProjectListLoading) {
            return const Loader();
          }

          if (state is ProjectListDisplaySuccess) {
            return ListView.builder(
                itemCount: state.projectList.length,
                itemBuilder: (context, index) {
                  final availableProject = state.projectList[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      title: Text(
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          availableProject.name),
                      subtitle: Text(
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 2,
                        availableProject.description,
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(projectDetailRoute,
                            arguments: availableProject);
                      },
                    ),
                  );
                });
          }

          return const Center(
              child: Text(
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  'Turn on your internet to fetch available projects'));
        },
      ),
    );
  }
}
