import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pacman/constaints.dart';
import 'package:pacman/ghost.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static int numberInRow = 11;
  int numberOfSquares = numberInRow * 16;
  int player = numberInRow * 14 + 1;
  int ghost1 = numberInRow * 2 - 2;
  int ghost2 = numberInRow * 9 - 1;
  int ghost3 = numberInRow * 11 - 2;
  List<int> food = [];
  // bool preGame = true;
  bool isMouthClosed = false;
  static bool reset = false;
  int score = 0;
  bool isPaused = false;
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
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0) {
                  direction = 'down';
                } else if (details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  direction = 'right';
                } else if (details.delta.dx < 0) {
                  direction = 'left';
                }
              },
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
                  if (isMouthClosed && player == index) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  } else if (player == index) {
                    switch (direction) {
                      case 'left':
                        return Transform.rotate(
                          angle: pi,
                          child: const MyPlayer(),
                        );
                      case 'right':
                        return const MyPlayer();
                      case 'up':
                        return Transform.rotate(
                          angle: 3 * pi / 2,
                          child: const MyPlayer(),
                        );
                      case 'down':
                        return Transform.rotate(
                          angle: pi / 2,
                          child: const MyPlayer(),
                        );
                      default:
                        return const MyPlayer();
                    }
                  }
                  //else if(ghost1 == index){
                  //   return const Ghost1();
                  // } else if(ghost2 == index){
                  //   return const Ghost2();
                  // }
                  if (ghost1 == index) {
                    return const Ghost();
                  } else if(ghost2 == index){
                    return const Ghost();
                  } else if(ghost3 == index){
                    return const Ghost();
                  } else if (Constains.barriers.contains(index)) {
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
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Score: $score",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                GestureDetector(
                  onTap: startGame,
                  child: const Text(
                    'P L A Y',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (!isPaused)
                  GestureDetector(
                    child: const Icon(
                      Icons.pause,
                      color: Colors.white,
                    ),
                    onTap: () => {
                      if (!isPaused)
                        {
                          isPaused = true,
                        }
                      else
                        {
                          isPaused = false,
                        },
                      const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                    },
                  ),
                if (isPaused)
                  GestureDetector(
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onTap: () => {
                      if (!isPaused)
                        {
                          isPaused = false,
                        }
                      else
                        {
                          isPaused = true,
                        },
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
