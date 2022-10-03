import 'package:flutter/material.dart';
import 'package:mobile/providers/auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      return Scaffold(
          body: ListView(
        children: [
          Container(
            width: 150.0,
            height: 100.0,
            padding: const EdgeInsets.only(top: 40.00),
            child: Center(child: Image.asset('assets/splash.png')),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-Mail Address',
                    hintText: 'Enter your registered e-mail address')),
          ),
          if (auth.error?["errors"]?["email"] != null)
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                    auth.error?["errors"]?["email"][0] ?? "Email Required")),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password')),
          ),
          if (auth.error?["errors"]?["password"] != null)
            Padding(
                padding: const EdgeInsets.all(10),
                child: Text(auth.error?["errors"]?["password"][0] ??
                    "Password Required")),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login/forgot');
            },
            child: const Text(
              'Forgot Password',
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),
          ),
          Padding(
              padding:
                  const EdgeInsets.only(bottom: 40.0, left: 10.0, right: 10.0),
              child: SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () {
                        auth.login(
                            emailController.text, passwordController.text);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      )))),
        ],
      ));
    });
  }
}
