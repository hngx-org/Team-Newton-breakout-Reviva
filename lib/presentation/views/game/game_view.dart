import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:newton_breakout_revival/data/physics/game_engine.dart';

class BrickBreakerGameScreen extends StatefulWidget {
  const BrickBreakerGameScreen({super.key});

  @override
  State<BrickBreakerGameScreen> createState() => _BrickBreakerGameScreenState();
}

class _BrickBreakerGameScreenState extends State<BrickBreakerGameScreen> {
  late GameEngine game;
  bool gameStarted = false;
  @override
  void initState() {
    super.initState();

    game = GameEngine(
      context,
      gameStarted: gameStarted,
    );
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: Colors.green.shade900, // Set the color you want
    ));
  }

  @override
  void dispose() {
    game.dispose();
    game.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GameWidget(
                    game: game,
                    backgroundBuilder: (context) {
                      return const Center(
                        child: Opacity(
                          opacity: 0.3,
                          child: FlutterLogo(
                            size: 350,
                          ),
                        ),
                      );
                    },
                  ),
                  // Center(
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // Handle button tap to start the game.
                  //       game.startGame(); // Call the startGame method in BrickBreakerGame
                  //       setState(() {
                  //         gameStarted = true; // Update the game state
                  //       });
                  //     },
                  //     child: const Text(
                  //       "Start Game",
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
