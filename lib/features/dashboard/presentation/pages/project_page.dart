import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/dashboard/presentation/bloc/project_bloc.dart';
import 'package:mind_lab_app/features/dashboard/presentation/widgets/card_item.dart';
import 'package:mind_lab_app/features/project_list/presentation/pages/project_list_page.dart';
import 'package:mind_lab_app/features/user_detail/presentation/pages/user_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  Future<void> _signOut() async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.auth.signOut();
    } on AuthException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(loginRoute);
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
        title: const Text('Subscribed Projects'),
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
            onPressed: _signOut,
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProjectBloc, ProjectState>(
        listener: (context, state) {
          if (state is ProjectFailure) {
            showSnackBar(context, 'Error while loading subscribed projects!');
          }
        },
        builder: (context, state) {
          if (state is ProjectLoading) {
            return const Loader();
          }

          if (state is ProjectDisplaySuccess) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (MediaQuery.of(context).orientation ==
                          Orientation.portrait)
                      ? 2
                      : 3),
              itemCount: state.projectList.length,
              itemBuilder: (BuildContext context, index) {
                final project = state.projectList[index];
                return CardItem(
                    text: project.project.name,
                    image: 'lib/assets/images/rashid_rover.png',
                    onTap: () =>
                        Navigator.pushNamed(context, roverMainPageRoute));
              },
            );
          }

          return const Center(
            child: Text("To get access, Please subscribe to a project"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          icon: const Icon(CupertinoIcons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ProjectListPage()));
          },
          label: const Text('Add Project')),
    );
  }
}
