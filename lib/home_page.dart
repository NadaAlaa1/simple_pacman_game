import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pacman/constaints.dart';
import 'package:pacman/pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 14 + 1;
  // int ghost1 = numberInRow * 2 - 2;
  // int ghost2 = numberInRow * 9 - 1;
  // int ghost3 = numberInRow * 11 - 2;
  List<int> food = [];
  // bool preGame = true;
  bool isMouthClosed = false;
  static bool reset = false;
  int score = 0;
  // bool isPaused = false;
  // AudioPlayer advancedPlayer = AudioPlayer();
  // AudioPlayer advancedPlayer2 = AudioPlayer();
  // AudioCache audioInGame = AudioCache(prefix: 'assets/');
  // AudioCache audioManch = AudioCache(prefix: 'assets/');
  // AudioCache audioDeath = AudioCache(prefix: 'assets/');
  // AudioCache audioPaused = AudioCache(prefix: 'assets/');
  String direction = 'right';
  // String ghostLast = 'left';
  // String ghostLast2 = 'left';
  // String ghostLast3 = 'down';

  void resetGame() {
    setState(() {
      reset = true;
      player = numberInRow * 15 + 1;
      food.clear();
      direction = 'right';
      score = 0;
    });

    Future.delayed(
        const Duration(
          seconds: 2,
        ), () {
      reset = false;
    });
  }

  void startGame() {
    getFood();
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (reset) {
        timer.cancel();
      }
      if (food.contains(player)) {
        food.remove(player);
        score++;
      }

      if (timer.isActive) {
        switch (direction) {
          case 'left':
            moveLeft();
            break;
          case 'right':
            moveRight();
            break;
          case 'up':
            moveUp();
            break;
          case 'down':
            moveDown();
            break;
        }
      }
    });
  }

  void getFood() {
    for (var i = 0; i < numberOfSquares; i++) {
      if (!Constains.barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    setState(() {
      if (!Constains.barriers.contains(player - 1)) {
        player--;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!Constains.barriers.contains(player + 1)) {
        player++;
      }
    });
  }

  void moveUp() {
    setState(() {
      if (!Constains.barriers.contains(player - numberInRow)) {
        player -= numberInRow;
      }
    });
  }

  void moveDown() {
    setState(() {
      if (!Constains.barriers.contains(player + numberInRow)) {
        player += numberInRow;
      }
    });
  }

  // @override
  // void initState() {
  //   getFood();
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            flex: (MediaQuery.of(context).size.height.toInt() * 0.0139).toInt(),
            child: GridView.builder(
              padding: (MediaQuery.of(context).size.height.toInt() * 0.0139)
                          .toInt() >
                      10
                  ? const EdgeInsets.only(top: 80)
                  : const EdgeInsets.only(top: 20),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: numberOfSquares,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberInRow,
              ),
              itemBuilder: (BuildContext context, int index) {
                // if(player == index){
                //   return const Player();
                // } else if(ghost1 == index){
                //   return const Ghost1();
                // } else if(ghost2 == index){
                //   return const Ghost2();
                // } else if(ghost3 == index){
                //   return const Ghost3();
                // }
                if (Constains.barriers.contains(index)) {
                  return Pixel(
                    innerColor: Colors.blue[900],
                    outerColor: Colors.blue[800],
                  );
                } else {
                  return const Pixel(
                    innerColor: Colors.black,
                    outerColor: Colors.black,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
