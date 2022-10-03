import 'package:flutter/material.dart';
import 'package:mobile/ui/screens/drills/correct_answer.dart';

class DrillsScreen extends StatelessWidget {
  const DrillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: Colors.white,
                child: Text(
                  "Height ${constraints.maxHeight.toString()}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const Positioned(
                child: CorrectAnswer(),
              )
            ],
          );
        },
      ),
    );
  }
}
