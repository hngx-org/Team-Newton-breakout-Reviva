// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:newton_breakout_revival/core/entites/ball.dart';
import 'package:newton_breakout_revival/core/entites/brick.dart';
import 'package:newton_breakout_revival/core/entites/paddle.dart';
import 'package:newton_breakout_revival/core/entites/power_up.dart';
import 'package:newton_breakout_revival/core/entites/shield.dart';
import 'package:newton_breakout_revival/core/enums/power_up_type.dart';
import 'package:newton_breakout_revival/data/global_provider/global_provider.dart';
import 'package:newton_breakout_revival/data/physics/brick_creator.dart';
import 'package:provider/provider.dart';

class GameEngine extends FlameGame
    with PanDetector, DoubleTapDetector, HasCollisionDetection {
  final BuildContext context;
  final GlobalKey key = GlobalKey();
  Size viewport = const Size(0, 0);
  bool gameStarted = false;
  bool gamePaused = false;
  bool gameOver = false;
  bool levelUp = false;
  int levelStatus = 1;
  GameEngine(this.context, {required this.gameStarted}) {
    // Add a lifecycle listener to get the viewport width when the game is resized.
    viewport =
        MediaQueryData.fromView(WidgetsBinding.instance.renderView.flutterView)
            .size;
  }
  late PaddleComponent paddle;
  late BallComponent ball;
  late BrickCreator brickC;
  late TextComponent textComponent;
  late GlobalProvider provider;
  late Shield shield;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    paddle = PaddleComponent();
    brickC = BrickCreator(this);

    shield = Shield();
    ball = BallComponent(
        player: paddle,
        onGameOver: () {
          provider.live--;

          if (provider.live > 0) {
            resetLive();
          } else {
            endGame();
          }
          provider.update();
        });
    provider = Provider.of<GlobalProvider>(context, listen: false);
    add(paddle);
    addAll([ScreenHitbox()]);
    add(ball);

    brickC.createBricks();
    setupText("Double Tap to \n     start");
    provider.live = 3;
    provider.update();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    final newPlayerPosition = paddle.position + info.delta.global;
    if (newPlayerPosition.x - paddle.width / 2 >= 0) {
      if (newPlayerPosition.x + paddle.width / 2 <= size.x) {
        paddle.position.x = newPlayerPosition.x;
      }
    }
    super.onPanUpdate(info);
  }

  @override
  void onDoubleTap() {
    if (gameOver == true) {
      startOver();
    } else if (gameStarted == false) {
      remove(textComponent);
      startGame();
    }
    if (levelUp == true) {
      remove(textComponent);
      nextlevel();
    }

    super.onDoubleTap();
  }

  void applyPowerUp(PowerUp powerUp) async {
    provider.activatePowerUp(powerUp);
    switch (powerUp.type) {
      case PowerUpType.ENLARGE_PADDLE:
        if (paddle.powerUpActive == false) {
          paddle.increaseSize();
        }
      case PowerUpType.BIG_BALL:
        if (ball.bigBallActive == false) {
          ball.increaseBall();
        }
      case PowerUpType.SHIELD:
        if (shield.powerUpActive == false) {
          shield.powerUpActive = true;
          add(shield);
          await Future.delayed(const Duration(seconds: 10));
          shield.powerUpActive = false;
          remove(shield);
        }
      default:
    }
  }

  void setupText(String text) {
    textComponent = TextComponent(
        text: text, // Replace with your desired text
        textRenderer: TextPaint(
            style: const TextStyle(
          fontFamily: 'Minecraft',
          fontSize: 25,
        )));
    // Set the position for your text component.
    textComponent.position =
        Vector2(100, size.y / 2.2); // Adjust the coordinates as needed
    add(textComponent); // Add the text component to the game.
  }

  void startGame() {
    gameStarted = true;
    ball.launch();
  }

  void nextlevel() {
    levelStatus++;
    provider.stopGlobalMusic();
    brickC.createBricks();
    provider.live = 3;
    provider.update();
    levelUp = false;
    ball.launch();
    paddle.onLoad();
  }

  void startOver() {
    provider.stopGlobalMusic();
    removeWhere((component) => component is BrickComponent);
    brickC.createBricks();
    provider.live = 3;
    provider.score = 0;
    provider.update();
    remove(textComponent);
    gameOver = false;
    startGame();
    paddle.onLoad();
  }

  void endGame() {
    gameOver = true;
    gameStarted = false;
    provider.playGlobalMusic();
    setupText("GAME OVER\n\n Double tap to\n start all over");
    if (provider.isSongPlaying) {
      provider.playGlobalMusic();
    }
  }

  void pauseGame() {
    gamePaused = !gamePaused;
    if (gamePaused == true) {
      pauseEngine();
    } else {
      resumeEngine();
    }
    provider.update();
  }

  void resetLive() {
    gameStarted = false;
    setupText("Double Tap screen\n    to continue");
    paddle.onLoad();
  }

  void dispose() {
    removeAll([
      paddle,
      ball,
    ]);
  }

  @override
  void onDispose() {
    removeAll([paddle, ball]);
    super.onDispose();
  }

  ///// THESE FEATURES ARE UNDER TESTING
  ///
  ///
  ///
  void drawFrame(Canvas canvas) {
    final framePaint = Paint()
      ..color = Colors.green.shade900 // Frame color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0; // Frame border width (adjust as needed)

    final frameRect = Rect.fromPoints(
      const Offset(0, 0), // Top-left corner of the frame
      Offset(size.x, size.y), // Bottom-right corner of the frame
    );

    canvas.drawRect(frameRect, framePaint);
  }

  void setLevel() {
    levelUp = true;
    ball.velocity = Vector2.zero();
    ball.position = Vector2(size.x / 2, size.y - 45);
    setupText(
        "Level $levelStatus achieved \n\nDouble Tap to\n move to Level ${levelStatus++}");
  }
}
