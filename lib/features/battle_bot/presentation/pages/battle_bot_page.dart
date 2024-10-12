import 'package:flutter/material.dart';

class BattleBotPage extends StatefulWidget {
  const BattleBotPage({super.key});

  @override
  State<BattleBotPage> createState() => _BattleBotPageState();
}

class _BattleBotPageState extends State<BattleBotPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Battle Bot"),
      ),
    );
  }
}
