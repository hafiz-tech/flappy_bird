import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final double barrierWidth;
  final double barrierHeight;
  final double barrierX;
  final bool isThisBottomBarrier;
  const MyBarrier({super.key, required this.barrierWidth, required this.barrierHeight, required this.barrierX, required this.isThisBottomBarrier});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth), isThisBottomBarrier ? 1 : -1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.25),
              blurRadius: 5,
              spreadRadius: 3
            )
          ]
        ),
        width: MediaQuery.of(context).size.width * barrierWidth /  2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      )
    );
  }
}
