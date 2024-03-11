import 'package:flutter/material.dart';

class MyCover extends StatelessWidget {
  final bool gameStarted;
  const MyCover({super.key, required this.gameStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0,-0.5),
      child: Text(
        gameStarted? "": "T A P  T O  P L A Y",
        style: const TextStyle(
            color: Colors.white,
            fontSize: 20
        ),
      ),
    );
  }
}
