import 'dart:async';

import 'package:flappy_bird/MyBarrier.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flappy_bird/myCover.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //BIRD VARIABLES
  static double birdY = 0.0;
  double initialPos = birdY;
  double height = 0.0;
  double time = 0.0;
  double gravity = -4.9; //how strong the gravity is
  double velocity = 2.0; // how strong the jump is
  double birdWidth = 0.1; // out of 2, 2 being the entire width of the screen
  double birdHeight = 0.1; // out of 2, 2 being the entire height of the screen

  //Game Settings
  bool gameStarted = false;

  //barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6]
  ];

  int score= 0;

  void startGame(){
    gameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // a real physics jump is the same as upside down parabola
      // so this is a simple quadratic equation
      height = gravity * time * time + velocity * time;
      if(mounted){
        setState(() {
          birdY = initialPos - height;
        });
      }

      // if bird is dead
      if(birdDead()){
        timer.cancel();
        _showDialog();
      }

      // move map
      moveMap();

      time += 0.01;
    });
  }

  bool birdDead(){
    if(birdY < -1 || birdY > 1){
      return true;
    }

    for(int i = 0; i < barrierX.length; i++){
      if(barrierX[i] <= birdWidth && barrierX[i] + barrierWidth >= -birdWidth && (birdY <= -1 + barrierHeight[i][0]
      || birdY + birdHeight >= 1 - barrierHeight[i][1])){
        return true;
      }
    }

    return false;
  }

  void jump(){
   if(mounted){
     setState(() {
       time = 0;
       initialPos = birdY;
     });
   }
  }

  void resetGame(){
    Navigator.pop(context);
    if(mounted){
      setState(() {
        birdY = 0.0;
        gameStarted = false;
        time = 0.0;
        initialPos = birdY;
      });
    }
  }

  moveMap(){
    for(int i = 0; i < barrierX.length; i++){
      if(mounted){
        setState(() {
          barrierX[i] -= 0.005;
        });
      }
      if(barrierX[i] < -1.5){
        barrierX[i] += 3;
      }
    }
  }

  void _showDialog(){
    showDialog(
        barrierDismissible: false,
        context: context, builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.brown,
        title: const Center(
          child: Text("G A M E  O V E R",
          style: TextStyle(color: Colors.white)),
        ),
        actions: [
          GestureDetector(
            onTap: resetGame,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                padding: const EdgeInsets.all(7),
                color: Colors.white,
                child: const Text("PLAY AGAIN",
                style: TextStyle(color: Colors.brown),),
              ),
            ),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameStarted? jump:startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 3,
                child: Container(color: const Color(0xFF70C5CE),
                  child: Center(
                    child: Stack(
                      children: [
                        //My Bird
                        MyBird(birdY: birdY,
                        birdHeight: birdHeight,
                        birdWidth: birdWidth),

                        //My Cover
                        MyCover(gameStarted: gameStarted),

                        //Barriers
                        MyBarrier(barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][0],
                            barrierX: barrierX[0],
                            isThisBottomBarrier: false),

                        MyBarrier(barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][1],
                            barrierX: barrierX[0],
                            isThisBottomBarrier: true),

                        MyBarrier(barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][0],
                            barrierX: barrierX[1],
                            isThisBottomBarrier: false),

                        MyBarrier(barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][1],
                            barrierX: barrierX[1],
                            isThisBottomBarrier: true),


                      ],
                    ),
                  ),)),
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                  color: Colors.brown,
                  boxShadow: [
                    BoxShadow(
                  color: Colors.brown.withOpacity(0.25),
                    blurRadius: 5,
                    spreadRadius: 5
                  )
                  ]
                  ),
                  padding: const EdgeInsets.all(20),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(score.toString(),style: const TextStyle(color: Colors.white,fontSize: 50,fontWeight: FontWeight.w300),),
                          const Text("Score",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),)
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("0",style: TextStyle(color: Colors.white,fontSize: 50,fontWeight: FontWeight.w300),),
                          Text("Best Score",style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w500),)
                        ],
                      ),
                    ],
                  ),
                ))
          ],
        ),
      )
    );
  }
}
