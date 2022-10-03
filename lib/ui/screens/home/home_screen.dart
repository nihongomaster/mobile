import 'package:flutter/material.dart';
import 'package:mobile/providers/auth.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) {
        return Column(
          children: [
            const Text("Welcome to Nihongo Master"),
            ElevatedButton(
              onPressed: auth.logout,
              child: const Text("Logout"),
            )
          ],
        );
      },
    );
  }
}
