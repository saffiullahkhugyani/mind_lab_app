import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';
import 'package:mind_lab_app/core/common/widgets/loader.dart';
import 'package:mind_lab_app/core/utils/pick_image.dart';
import 'package:mind_lab_app/core/utils/show_snackbar.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_category_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skill_tag_entity.dart';
import 'package:mind_lab_app/features/user_detail/domain/entities/skills_type_entity.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_bloc.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_event.dart';
import 'package:mind_lab_app/features/user_detail/presentation/bloc/add_certificate_bloc/add_certificate_state.dart';

class AddCertificate extends StatefulWidget {
  const AddCertificate({Key? key}) : super(key: key);

  @override
  _AddCertificateState createState() => _AddCertificateState();
}

class _AddCertificateState extends State<AddCertificate> {
  SkillTypeEntity? selectedSkillTypeEntity;
  SkillTagEntity? selectedSkillTagEntity;
  SkillCategoryEntity? selectedCategoryEntity;
  File? image;
  String? certificateName;
  final formKey = GlobalKey<FormState>();

  final certificateNameController = TextEditingController();

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
      final studentId =
          (context.read<AppStudentCubit>().state as AppStudentSelected)
              .student
              .id;
      context.read<AddCertificateBloc>().add(
            UploadCertificateEvent(
              studentId: studentId,
              certificateName: certificateNameController.text.trim(),
              image: image!,
              skillType: selectedSkillTypeEntity?.name,
              skillCategory: selectedCategoryEntity?.categoryName,
              skillTag: selectedSkillTagEntity?.name,
            ),
          );
    } else {
      showFlashBar(
        context,
        "Please select all the fields",
        FlashBarAction.warning,
      );
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
        title: const Text("Upload Certificate"),
      ),
      body: BlocConsumer<AddCertificateBloc, AddCertificateState>(
        listener: (context, state) {
          if (state is SkillDataFailure) {
            if (state.error == "Duplicate") {
              showFlashBar(
                context,
                "Certificate already exists",
                FlashBarAction.error,
              );
            }
            Navigator.of(context).pop();
          } else if (state is UploadCertificateSuccess) {
            showFlashBar(
              context,
              "Certificate of ${certificateNameController.text.trim()} uploaded successfully",
              FlashBarAction.success,
            );
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
                    TextFormField(
                      controller: certificateNameController,
                      decoration: InputDecoration(
                        hintText: "Certificate name",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Certificate name";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<SkillTypeEntity>(
                      decoration: const InputDecoration(
                        label: Text("Select a skill type"),
                      ),
                      value: selectedSkillTypeEntity,
                      onChanged: (value) {
                        setState(() {
                          selectedSkillTypeEntity = value;
                          selectedCategoryEntity = null;
                          selectedSkillTagEntity = null;
                        });
                      },
                      items: state.skillTypes
                          .map<DropdownMenuItem<SkillTypeEntity>>(
                            (skillType) => DropdownMenuItem(
                              value: skillType,
                              child: Text(skillType.name!),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<SkillCategoryEntity>(
                      decoration: const InputDecoration(
                        label: Text("Select a category"),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryEntity = value;
                          selectedSkillTagEntity = null;
                        });
                      },
                      value: selectedCategoryEntity,
                      items: _buildHashTagDropdownEntries(state),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<SkillTagEntity>(
                      decoration:
                          const InputDecoration(label: Text("Select a tag")),
                      onChanged: (value) {
                        setState(() {
                          selectedSkillTagEntity = value;
                        });
                      },
                      value: selectedSkillTagEntity,
                      items: _buildSkillDropdownEntries(state),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        uploadCertificate();
                      },
                      child: const Text("Upload Certificate"),
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

  List<DropdownMenuItem<SkillCategoryEntity>> _buildHashTagDropdownEntries(
      SkillDataSuccess state) {
    return state.skillCategories
        .where(
            (category) => category.skillTypeId == selectedSkillTypeEntity?.id)
        .map(
          (skillCategory) => DropdownMenuItem<SkillCategoryEntity>(
            value: skillCategory,
            child: Text(skillCategory.categoryName!),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<SkillTagEntity>> _buildSkillDropdownEntries(
      SkillDataSuccess state) {
    return state.skillTags
        .where((tags) => tags.skillCategoryId == selectedCategoryEntity?.id)
        .map<DropdownMenuItem<SkillTagEntity>>(
          (skillEntity) => DropdownMenuItem(
            value: skillEntity,
            child: Text(skillEntity.name!),
          ),
        )
        .toList();
  }
}
