import 'dart:async';
import 'dart:math';
import 'dart:ffi';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:pacman/constaints.dart';
import 'package:pacman/ghost.dart';
import 'package:pacman/ghost2.dart';
import 'package:pacman/ghost3.dart';
import 'package:pacman/path.dart';
import 'package:pacman/pixel.dart';
import 'package:pacman/player.dart';
import 'package:flutter/rendering.dart';

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
  bool preGame = true;
  bool isMouthClosed = false;
  static bool reset = false;
  int score = 0;
  var controller;
  bool isPaused = false;
  AudioPlayer advancedPlayer = AudioPlayer();
  AudioPlayer advancedPlayer2 = AudioPlayer();
  AudioCache audioInGame = AudioCache(prefix: 'assets/');
  AudioCache audioManch = AudioCache(prefix: 'assets/');
  AudioCache audioDeath = AudioCache(prefix: 'assets/');
  AudioCache audioPaused = AudioCache(prefix: 'assets/');
  String direction = 'right';
  String ghostLast = 'left';
  String ghostLast2 = 'left';
  String ghostLast3 = 'down';

  // void resetGame() {
  //   setState(() {
  //     reset = true;
  //     player = numberInRow * 15 + 1;
  //     food.clear();
  //     direction = 'right';
  //     score = 0;
  //   });

  //   Future.delayed(
  //       const Duration(
  //         seconds: 2,
  //       ), () {
  //     reset = false;
  //   });
  // }

  void restart() {
    startGame();
  }

  void getFood() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (!Constains.barriers.contains(i)) {
        food.add(i);
      }
    }
  }

  void moveLeft() {
    if (!Constains.barriers.contains(player - 1)) {
      setState(() {
        player--;
      });
    }
  }

  void moveRight() {
    if (!Constains.barriers.contains(player + 1)) {
      setState(() {
        player++;
      });
    }
  }

  void moveUp() {
    if (!Constains.barriers.contains(player - numberInRow)) {
      setState(() {
        player -= numberInRow;
      });
    }
  }

  void moveDown() {
    if (!Constains.barriers.contains(player + numberInRow)) {
      setState(() {
        player += numberInRow;
      });
    }
  }

  void startGame() {
    if (preGame) {
      advancedPlayer = AudioPlayer();
      // audioInGame = AudioCache(fixedPlayer: advancedPlayer);
      // audioPaused = AudioCache(fixedPlayer: advancedPlayer2);
      audioInGame.load('pacman_beginning.wav');
      preGame = false;
      getFood();

      Timer.periodic(const Duration(milliseconds: 10), (timer) {
        if (isPaused) {
        } else {
          advancedPlayer.resume();
        }
        if (player == ghost1 || player == ghost2 || player == ghost3) {
          advancedPlayer.stop();
          audioDeath.load('pacman_death.wav');
          setState(() {
            player = -1;
          });
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Center(
                    child: Text("Game Over!"),
                  ),
                  content: Text("Your Score : " + (score).toString()),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        audioInGame.load('pacman_beginning.wav');
                        setState(() {
                          player = numberInRow * 14 + 1;
                          ghost1 = numberInRow * 2 - 2;
                          ghost2 = numberInRow * 9 - 1;
                          ghost3 = numberInRow * 11 - 2;
                          isPaused = false;
                          preGame = false;
                          isMouthClosed = false;
                          direction = "right";
                          food.clear();
                          getFood();
                          score = 0;
                          Navigator.pop(context);
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Colors.white,
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF0D47A1),
                              Color(0xFF1976D2),
                              Color(0xFF42A5F5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: const Text('Restart'),
                      ),
                    )
                  ],
                );
              });
        }
      });
      Timer.periodic(const Duration(milliseconds: 190), (timer) {
        if (!isPaused) {
          moveGhost();
          moveGhost2();
          moveGhost3();
        }
      });
      Timer.periodic(const Duration(milliseconds: 170), (timer) {
        setState(() {
          isMouthClosed = !isMouthClosed;
        });
        if (food.contains(player)) {
          // audioMunch.play('pacman_chomp.wav');
          setState(() {
            food.remove(player);
          });
          score++;
        }
        switch (direction) {
          case "left":
            if (!isPaused) moveLeft();
            break;
          case "right":
            if (!isPaused) moveRight();
            break;
          case "up":
            if (!isPaused) moveUp();
            break;
          case "down":
            if (!isPaused) moveDown();
            break;
        }
      });
    }
  }

  void moveGhost() {
    switch (ghostLast) {
      case "left":
        if (!Constains.barriers.contains(ghost1 - 1)) {
          setState(() {
            ghost1--;
          });
        } else {
          if (!Constains.barriers.contains(ghost1 + numberInRow)) {
            setState(() {
              ghost1 += numberInRow;
              ghostLast = "down";
            });
          } else if (!Constains.barriers.contains(ghost1 + 1)) {
            setState(() {
              ghost1++;
              ghostLast = "right";
            });
          } else if (!Constains.barriers.contains(ghost1 - numberInRow)) {
            setState(() {
              ghost1 -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
      case "right":
        if (!Constains.barriers.contains(ghost1 + 1)) {
          setState(() {
            ghost1++;
          });
        } else {
          if (!Constains.barriers.contains(ghost1 - numberInRow)) {
            setState(() {
              ghost1 -= numberInRow;
              ghostLast = "up";
            });
          } else if (!Constains.barriers.contains(ghost1 + numberInRow)) {
            setState(() {
              ghost1 += numberInRow;
              ghostLast = "down";
            });
          } else if (!Constains.barriers.contains(ghost1 - 1)) {
            setState(() {
              ghost1--;
              ghostLast = "left";
            });
          }
        }
        break;
      case "up":
        if (!Constains.barriers.contains(ghost1 - numberInRow)) {
          setState(() {
            ghost1 -= numberInRow;
            ghostLast = "up";
          });
        } else {
          if (!Constains.barriers.contains(ghost1 + 1)) {
            setState(() {
              ghost1++;
              ghostLast = "right";
            });
          } else if (!Constains.barriers.contains(ghost1 - 1)) {
            setState(() {
              ghost1--;
              ghostLast = "left";
            });
          } else if (!Constains.barriers.contains(ghost1 + numberInRow)) {
            setState(() {
              ghost1 += numberInRow;
              ghostLast = "down";
            });
          }
        }
        break;
      case "down":
        if (!Constains.barriers.contains(ghost1 + numberInRow)) {
          setState(() {
            ghost1 += numberInRow;
            ghostLast = "down";
          });
        } else {
          if (!Constains.barriers.contains(ghost1 - 1)) {
            setState(() {
              ghost1--;
              ghostLast = "left";
            });
          } else if (!Constains.barriers.contains(ghost1 + 1)) {
            setState(() {
              ghost1++;
              ghostLast = "right";
            });
          } else if (!Constains.barriers.contains(ghost1 - numberInRow)) {
            setState(() {
              ghost1 -= numberInRow;
              ghostLast = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost2() {
    switch (ghostLast2) {
      case "left":
        if (!Constains.barriers.contains(ghost2 - 1)) {
          setState(() {
            ghost2--;
          });
        } else {
          if (!Constains.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!Constains.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Constains.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
      case "right":
        if (!Constains.barriers.contains(ghost2 + 1)) {
          setState(() {
            ghost2++;
          });
        } else {
          if (!Constains.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          } else if (!Constains.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          } else if (!Constains.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          }
        }
        break;
      case "up":
        if (!Constains.barriers.contains(ghost2 - numberInRow)) {
          setState(() {
            ghost2 -= numberInRow;
            ghostLast2 = "up";
          });
        } else {
          if (!Constains.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Constains.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!Constains.barriers.contains(ghost2 + numberInRow)) {
            setState(() {
              ghost2 += numberInRow;
              ghostLast2 = "down";
            });
          }
        }
        break;
      case "down":
        if (!Constains.barriers.contains(ghost2 + numberInRow)) {
          setState(() {
            ghost2 += numberInRow;
            ghostLast2 = "down";
          });
        } else {
          if (!Constains.barriers.contains(ghost2 - 1)) {
            setState(() {
              ghost2--;
              ghostLast2 = "left";
            });
          } else if (!Constains.barriers.contains(ghost2 + 1)) {
            setState(() {
              ghost2++;
              ghostLast2 = "right";
            });
          } else if (!Constains.barriers.contains(ghost2 - numberInRow)) {
            setState(() {
              ghost2 -= numberInRow;
              ghostLast2 = "up";
            });
          }
        }
        break;
    }
  }

  void moveGhost3() {
    switch (ghostLast) {
      case "left":
        if (!Constains.barriers.contains(ghost3 - 1)) {
          setState(() {
            ghost3--;
          });
        } else {
          if (!Constains.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          } else if (!Constains.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Constains.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
      case "right":
        if (!Constains.barriers.contains(ghost3 + 1)) {
          setState(() {
            ghost3++;
          });
        } else {
          if (!Constains.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          } else if (!Constains.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Constains.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "up":
        if (!Constains.barriers.contains(ghost3 - numberInRow)) {
          setState(() {
            ghost3 -= numberInRow;
            ghostLast3 = "up";
          });
        } else {
          if (!Constains.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Constains.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Constains.barriers.contains(ghost3 + numberInRow)) {
            setState(() {
              ghost3 += numberInRow;
              ghostLast3 = "down";
            });
          }
        }
        break;
      case "down":
        if (!Constains.barriers.contains(ghost3 + numberInRow)) {
          setState(() {
            ghost3 += numberInRow;
            ghostLast3 = "down";
          });
        } else {
          if (!Constains.barriers.contains(ghost3 - 1)) {
            setState(() {
              ghost3--;
              ghostLast3 = "left";
            });
          } else if (!Constains.barriers.contains(ghost3 + 1)) {
            setState(() {
              ghost3++;
              ghostLast3 = "right";
            });
          } else if (!Constains.barriers.contains(ghost3 - numberInRow)) {
            setState(() {
              ghost3 -= numberInRow;
              ghostLast3 = "up";
            });
          }
        }
        break;
    }
  }

  // void getFood() {
  //   for (var i = 0; i < numberOfSquares; i++) {
  //     if (!Constains.barriers.contains(i)) {
  //       food.add(i);
  //     }
  //   }
  // }

  // void moveLeft() {
  //   setState(() {
  //     if (!Constains.barriers.contains(player - 1)) {
  //       player--;
  //     }
  //   });
  // }

  // void moveRight() {
  //   setState(() {
  //     if (!Constains.barriers.contains(player + 1)) {
  //       player++;
  //     }
  //   });
  // }

  // void moveUp() {
  //   setState(() {
  //     if (!Constains.barriers.contains(player - numberInRow)) {
  //       player -= numberInRow;
  //     }
  //   });
  // }

  // void moveDown() {
  //   setState(() {
  //     if (!Constains.barriers.contains(player + numberInRow)) {
  //       player += numberInRow;
  //     }
  //   });
  // }

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
                  } else if (ghost2 == index) {
                    return const Ghost2();
                  } else if (ghost3 == index) {
                    return const Ghost3();
                  } else if (Constains.barriers.contains(index)) {
                    return Pixel(
                      innerColor: Colors.blue[900],
                      outerColor: Colors.blue[800],
                    );
                  } else if (preGame || food.contains(index)) {
                      return const MyPath(
                        innerColor: Colors.yellow,
                        outerColor: Colors.black,
                        // child: Text(index.toString()),
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
