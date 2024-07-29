import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/pick_image.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_hashtag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_entity.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_event.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_state.dart';

class AddCertificate extends StatefulWidget {
  const AddCertificate({Key? key}) : super(key: key);

  @override
  _AddCertificateState createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
  SkillEntity? selectedSkillEntity;
  SkillHashTagEntity? selectedHashtagEntity;
  SkillCategoryEntity? selectedCategoryEntity;
  File? image;
  final formKey = GlobalKey<FormState>();

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadCertificate() {
    if (formKey.currentState!.validate() && image != null) {
      final userId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<AddCertificateBloc>().add(
            UploadCertificateEvent(
              userId: userId,
              skillId: selectedSkillEntity!.id.toString(),
              image: image!,
            ),
          );
    } else {
      showFlushBar(
          context, "Please select all the fields", FlushBarAction.warning);
    }
  }

  @override
  void initState() {
    context.read<AddCertificateBloc>().add(FetchSkillData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Certificate"),
      ),
      body: BlocConsumer<AddCertificateBloc, AddCertificateState>(
        listener: (context, state) {
          if (state is SkillDataFailure) {
            if (state.error == "Duplicate") {
              showFlushBar(
                context,
                "Certificate already exists",
                FlushBarAction.error,
              );
            }
            Navigator.of(context).pop();
          } else if (state is UploadCertificateSuccess) {
            showFlushBar(
                context,
                "Certificate of ${selectedSkillEntity!.name} uploaded successfully",
                FlushBarAction.success);
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is SkillDataLoading) {
            return const Loader();
          }
          if (state is SkillDataSuccess) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            image != null
                                ? Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 5,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                      ],
                                      shape: BoxShape.rectangle,
                                    ),
                                    child: Image(
                                      image: FileImage(image!),
                                    ),
                                  )
                                : Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.1),
                                        ),
                                      ],
                                      shape: BoxShape.rectangle,
                                      image: const DecorationImage(
                                          fit: BoxFit.scaleDown,
                                          image: AssetImage(
                                              'lib/assets/images/no-image-selected.png')),
                                    ),
                                  ),
                            Positioned(
                              bottom: -10,
                              right: -10,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Colors.white,
                                    ),
                                    color: Colors.grey),
                                child: const Icon(Icons.edit),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<SkillCategoryEntity>(
                      decoration: const InputDecoration(
                        label: Text("Select a skill category"),
                      ),
                      value: selectedCategoryEntity,
                      validator: (value) {
                        if (value == null) {
                          return "Please select a category";
                        }

                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryEntity = value;
                          selectedHashtagEntity = null;
                          selectedSkillEntity = null;
                        });
                      },
                      items: state.skillCategories
                          .map<DropdownMenuItem<SkillCategoryEntity>>(
                            (categoryEntity) => DropdownMenuItem(
                              value: categoryEntity,
                              child: Text(categoryEntity.categoryName!),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<SkillHashTagEntity>(
                      decoration: const InputDecoration(
                        label: Text("Select a hashtag"),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedHashtagEntity = value;
                          selectedSkillEntity = null;
                        });
                      },
                      value: selectedHashtagEntity,
                      validator: (value) {
                        if (value == null) {
                          return "Please select a Hashtag";
                        }

                        return null;
                      },
                      items: _buildHashTagDropdownEntries(state),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<SkillEntity>(
                      decoration:
                          const InputDecoration(label: Text("Select a skill")),
                      onChanged: (value) {
                        setState(() {
                          selectedSkillEntity = value;
                        });
                      },
                      value: selectedSkillEntity,
                      validator: (value) {
                        if (value == null) {
                          return "Please select a skill";
                        }

                        return null;
                      },
                      items: _buildSkillDropdownEntries(state),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        uploadCertificate();
                      },
                      child: const Text("Add Certificate"),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Center(
            child: Text("Data not available"),
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<SkillHashTagEntity>> _buildHashTagDropdownEntries(
      SkillDataSuccess state) {
    return state.skillHashtags
        .where((hashtagEntity) =>
            hashtagEntity.categoryId == selectedCategoryEntity?.id)
        .map(
          (skillHashtagEntity) => DropdownMenuItem<SkillHashTagEntity>(
            value: skillHashtagEntity,
            child: Text(skillHashtagEntity.hashtagName!),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<SkillEntity>> _buildSkillDropdownEntries(
      SkillDataSuccess state) {
    return state.skills
        .where(
            (skillEntity) => skillEntity.hashtagId == selectedHashtagEntity?.id)
        .map<DropdownMenuItem<SkillEntity>>(
          (skillEntity) => DropdownMenuItem(
            value: skillEntity,
            child: Text(skillEntity.name!),
          ),
        )
        .toList();
  }
}
