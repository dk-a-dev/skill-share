import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zr/components/dashboard/roadmap.dart';
import 'package:zr/screens/auth_screen.dart';
import 'package:zr/screens/get_started.dart';
import 'package:zr/screens/home_screen.dart';
import 'package:zr/screens/leaderboard.dart';
import 'package:zr/screens/onboarding/screen1.dart';
import 'package:zr/screens/onboarding/screen2.dart';
import 'package:zr/screens/onboarding/screen3.dart';
import 'package:zr/screens/profile.dart';
import 'package:zr/screens/splash_screen.dart';
import 'firebase_options.dart';
import '../utils/screen_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZR-App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        ScreenInitializer.routeName: (context) => const ScreenInitializer(),
        GetStarted.routeName: (context) => const GetStarted(),
        Dashbaord.routeName: (context) => const Dashbaord(),
        Profile.routeName: (context) => const Profile(),
        AuthScreen.routeName: (context) => const AuthScreen(),
        ScreenOne.routename: (context) => const ScreenOne(),
        ScreenTwo.routeName: (context) => const ScreenTwo(),
        ScreenThree.routeName: (context) => const ScreenThree(),
        LeaderBoard.routeName: (context) => const LeaderBoard(),
        RoadMap.routeName: (context) => const RoadMap(),
      },
    );
  }
}
