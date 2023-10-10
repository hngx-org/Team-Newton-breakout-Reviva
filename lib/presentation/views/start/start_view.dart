// ignore_for_file: use_build_context_synchronously

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:newton_breakout_revival/presentation/views/game/game_view.dart';

import '../../../data/physics/game_engine.dart';

class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  @override
  void initState() {
    // _leaveLoading();
    print("Move to game");
    super.initState();
  }

  _leaveLoading() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BrickBreakerGameScreen(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage("assets/images/bg.jpg"),
              fit: BoxFit.fitWidth),
          gradient: RadialGradient(
            colors: [
              Colors.green.shade500.withOpacity(0.8),
              Colors.green.shade900.withOpacity(1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  "Newton",
                  style: TextStyle(
                      fontSize: 30, fontFamily: 'Game', color: Colors.white),
                ),
                const SizedBox(
                  height: 60,
                ),
                const Text(
                  "Breakout\nRevival",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 50, fontFamily: 'Game', color: Colors.white),
                ),
                const Spacer(),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.yellow.shade900, width: 4),
                      gradient: LinearGradient(
                          colors: [
                            Colors.green.shade500,
                            Colors.green.shade900,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      "Loading...",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Minecraft',
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

