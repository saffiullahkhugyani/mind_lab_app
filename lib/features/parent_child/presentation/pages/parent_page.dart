import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_child/app_child_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/constants/routes.dart';
import 'package:mind_lab_app/core/widgets/card_item.dart';
import 'package:mind_lab_app/features/parent_child/presentation/bloc/parent_child_bloc.dart';
import 'package:mind_lab_app/features/parent_child/presentation/pages/add_child_form.dart';

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
    log('in fetching data ');
    setState(() {
      context.read<ParentChildBloc>().add(GetChildrenEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Page'),
      ),
      body: BlocConsumer<ParentChildBloc, ParentChildState>(
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
                    context.read<AppChildCubit>().updateChild(child);
                    log("selected child: ${child.name}");
                    Navigator.of(context).pushNamed(dashboardRoute);
                  },
                );
              },
            );
          }

          return const Center(
            child: Text("No children found"),
          );
        },
      ),
    );
  }
}
