import 'dart:convert';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mind_lab_app/core/common/cubits/app_user/app_user_cubit.dart';

class Myidpage extends StatefulWidget {
  const Myidpage({super.key});

  @override
  State<Myidpage> createState() => _MyidpageState();
}

class _MyidpageState extends State<Myidpage> {
  // to get the player Id
  String generateShortUUID(String id) {
    var uuid = id; // Generate a standard UUID
    var bytes = utf8.encode(uuid); // Convert it to bytes
    var hash = sha256.convert(bytes); // Create a SHA-256 hash
    return hash.toString().substring(0, 5); // Return the first 8 characters
  }

  @override
  Widget build(BuildContext context) {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
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
                data: generateShortUUID(userId),
                barcode: Barcode.code128())
          ],
        ),
      ),
    );
  }
}
