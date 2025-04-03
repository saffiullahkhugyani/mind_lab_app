import 'package:barcode_widget/barcode_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_student/app_student_cubit.dart';

class Myidpage extends StatefulWidget {
  const Myidpage({super.key});

  @override
  State<Myidpage> createState() => _MyidpageState();
}

class _MyidpageState extends State<Myidpage> {
  @override
  Widget build(BuildContext context) {
    final userId = (context.read<AppStudentCubit>().state as AppStudentSelected)
        .student
        .id;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Player Id"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarcodeWidget(
                width: 200,
                height: 200,
                data: userId,
                barcode: Barcode.code128())
          ],
        ),
      ),
    );
  }
}
