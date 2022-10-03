import 'dart:async';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

// Represents the correct answer.  We show the progress for 3 seconds.
class CorrectAnswer extends StatefulWidget {
  const CorrectAnswer({super.key});

  @override
  State<CorrectAnswer> createState() => _CorrectAnswerState();
}

class _CorrectAnswerState extends State<CorrectAnswer> with TickerProviderStateMixin {
  late AnimationController progressController;

  late ConfettiController confettiController;

  @override
  void initState() {
    progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });

    // Bring on the confetti
    confettiController = ConfettiController(
      duration: const Duration(
        seconds: 3,
      ),
    );

    progressController.forward();
    confettiController.play();
    super.initState();
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          Opacity(
            opacity: 0.2,
            child: Container(
              color: Colors.black,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
            ),
          ),
          Center(
            child: SizedBox(
              width: (constraints.maxWidth * .75),
              height: 100,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.lightGreen,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConfettiWidget(
                            confettiController: confettiController,
                            blastDirectionality: BlastDirectionality.explosive,
                            numberOfParticles: 40,
                            shouldLoop: true,
                          ),
                        ),
                      ),
                      const Center(
                        child: Text(
                          "CORRECT",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          minHeight: 10,
                          value: progressController.value,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
