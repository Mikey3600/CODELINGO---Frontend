import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/skill_tree_screen.dart';
import '../screens/profile_screen.dart';

import '../screens/ai/ai_tutor_screen.dart'; 
import '../widgets/bottom_nav.dart';

class MainShell extends StatefulWidget {
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SkillTreePlaceholder(), 
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: BottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}


class SkillTreePlaceholder extends StatelessWidget {
  const SkillTreePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Learn Screen", style: TextStyle(fontSize: 24)),
    );
  }
}
