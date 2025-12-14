import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ChoosePathwayScreen extends StatefulWidget {
  const ChoosePathwayScreen({Key? key}) : super(key: key);

  @override
  State<ChoosePathwayScreen> createState() => _ChoosePathwayScreenState();
}

class _ChoosePathwayScreenState extends State<ChoosePathwayScreen> {
  final List<Map<String, dynamic>> languages = [
    {
      "name": "C",
      "color": const Color(0xFF00599C),
      "icon": Icons.data_object,
      "route": "/c_lessons"
    },
    {
      "name": "C++",
      "color": const Color(0xFF004C8C),
      "icon": Icons.code,
      "route": null
    },
    {
      "name": "Java",
      "color": const Color(0xFFED8B00),
      "icon": Icons.coffee,
      "route": null
    },
    {
      "name": "JavaScript",
      "color": const Color(0xFFF7DF1E),
      "icon": Icons.javascript,
      "route": null
    },
    {
      "name": "Python",
      "color": const Color(0xFF3776AB),
      "icon": Icons.terminal,
      "route": null
    },
  ];

  void _showStartDialog(String? route) {
    if (route == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Coming soon!'),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            Navigator.pop(context);
            Navigator.pushNamed(context, route);
          }
        });

        return Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth * 0.85;
              final maxHeight = constraints.maxHeight * 0.7;
              final size = maxWidth < maxHeight ? maxWidth : maxHeight;

              return SizedBox(
                width: size,
                height: size,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 2,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Let's begin the fun!",
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0A0E27),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Flexible(
                            flex: 8,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Lottie.asset(
                                "assets/character.json",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.black87,
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
              const SizedBox(height: 12),
              const Text(
                "Choose Your Pathway",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A202C),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Select a language to begin your journey.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: languages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    return _LanguageTile(
                      name: lang["name"],
                      icon: lang["icon"],
                      color: lang["color"],
                      onTap: () => _showStartDialog(lang["route"]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatefulWidget {
  final String name;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.name,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_LanguageTile> createState() => _LanguageTileState();
}

class _LanguageTileState extends State<_LanguageTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _tilt;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 260),
      vsync: this,
    );

    _tilt = Tween<double>(begin: 0, end: 0.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  void _animateTap() {
    _controller.forward().then((_) {
      _controller.reverse();
      widget.onTap();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_tilt.value),
          alignment: Alignment.center,
          child: Transform.scale(
            scale: _scale.value,
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: _animateTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey[200]!, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: widget.color.withOpacity(0.12),
                child: Icon(widget.icon, color: widget.color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[500]),
            ],
          ),
        ),
      ),
    );
  }
}
