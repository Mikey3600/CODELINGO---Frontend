// filename: lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';
import 'utils/colors.dart';

// PROVIDERS
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/skill_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/ai_tutor_provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved token BEFORE app starts
  final auth = AuthProvider();
  await auth.loadSavedToken(); 

  runApp(CodelingoApp(authProvider: auth));
}

class CodelingoApp extends StatelessWidget {
  final AuthProvider authProvider;
  const CodelingoApp({Key? key, required this.authProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => SkillProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => AITutorProvider()),
      ],
      child: MaterialApp(
        title: "Codelingo",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primaryGreen,
          fontFamily: "Roboto",
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: AppColors.textPrimary,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
