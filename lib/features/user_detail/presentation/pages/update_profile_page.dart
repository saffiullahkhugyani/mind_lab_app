import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdataProfilePage extends StatefulWidget {
  const UpdataProfilePage({super.key});

  @override
  State<UpdataProfilePage> createState() => _UpdataProfilePageState();
}

class _UpdataProfilePageState extends State<UpdataProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Update Profile page'),
      ),
    );
  }
}
