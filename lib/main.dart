import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mobile/providers/auth.dart';
import 'package:mobile/ui/screens/classroom/classroom_screen.dart';
import 'package:mobile/ui/screens/drills/drills_screen.dart';
import 'package:mobile/ui/screens/home/home_screen.dart';
import 'package:mobile/ui/screens/login/forgot_password_screen.dart';
import 'package:mobile/ui/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure our Widgets Binding engine is setup before doing anything
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Show our splash image
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Setup our primary widget
  // @todo Can setup any additional stuff here including
  // Check API token and see if we need to immediately login

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            Auth auth = Auth();
            auth.init();
            return auth;
          },
        ),
      ],
      child: const NihongoMaster(),
    ),
  );

  // Now we can remove our splash
  FlutterNativeSplash.remove();
}

class NihongoMaster extends StatelessWidget {
  const NihongoMaster({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(builder: (context, auth, child) {
      debugPrint("Inside top level consumer build.");
      debugPrint("Are we authenticated? ${auth.isAuthenticated}");
      if (!auth.isAuthenticated) {
        return MaterialApp(
          key: const ValueKey('loggedout-app'),
          title: 'Nihongo Master',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/login/forgot': (context) => const ForgotPasswordScreen(),
          },
        );
      } else {
        debugPrint("Attempting now to have the new material app.");
        return const LoggedInApp();
      }
    });
  }
}

class LoggedInApp extends StatefulWidget {
  const LoggedInApp({super.key});

  @override
  State<LoggedInApp> createState() => _LoggedInAppState();
}

class _LoggedInAppState extends State<LoggedInApp> {
  final List<Map<String, dynamic>> navigation = [
    {'label': 'Classroom', 'icon': () => const Icon(Icons.document_scanner), 'destination': () => const ClassroomScreen()},
    {'label': 'Drills', 'icon': () => const DrillsIcon(), 'destination': () => const DrillsScreen()},
    {'label': 'Home', 'icon': () => const Icon(Icons.dashboard), 'destination': () => const HomeScreen()},
  ];

  int selectedScreen = 2; // Home

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: navigation
              .map((e) => BottomNavigationBarItem(
                    icon: e['icon'](),
                    label: e['label'],
                  ))
              .toList(),
          onTap: selectScreen,
        ),
        body: navigation[selectedScreen]['destination'](),
      ),
    );
  }

  void selectScreen(index) {
    setState(() {
      selectedScreen = index;
    });
  }
}

class DrillsIcon extends StatelessWidget {
  const DrillsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: ((context, auth, child) {
        return Stack(
          children: [
            const Icon(Icons.notifications),
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 14,
                  minHeight: 14,
                ),
                child: Text(
                  auth.user?.drillsDue.toString() ?? "...",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
