import 'package:flutter/material.dart';

class MecanumCarPage extends StatefulWidget {
  const MecanumCarPage({super.key});

  @override
  State<MecanumCarPage> createState() => _MecanumCarPageState();
}

class _MecanumCarPageState extends State<MecanumCarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mecanum Car"),
      ),
    );
  }
}
