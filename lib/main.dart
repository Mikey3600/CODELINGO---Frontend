import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/choose_pathway_screen.dart';
import 'screens/c_lessons_screen.dart';
import 'screens/c_quiz_screen.dart';

void main() {
  runApp(const CodfofunApp());
}

class CodfofunApp extends StatelessWidget {
  const CodfofunApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codfofun',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0E27),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/choose-pathway': (context) => const ChoosePathwayScreen(),
        '/c_lessons': (context) => const CLessonsScreen(),
        '/c_quiz': (context) => const CQuizScreen(),
      },
    );
  }
}
