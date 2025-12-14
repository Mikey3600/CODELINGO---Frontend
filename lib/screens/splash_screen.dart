import 'package:flutter/material.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Animation Controllers
  late AnimationController _flickerController;
  late AnimationController _glowController;
  late AnimationController _subtitleController;
  late AnimationController _pulseController;

  // Animations
  late Animation<double> _textOpacity;
  late Animation<double> _textGlow;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _pulseAnimation;

  int _flickerPhase =
      0; // 0: dark, 1: first flicker, 2: second flicker, 3: stable

  @override
  void initState() {
    super.initState();
      _initializeAnimations();
    _playSound();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    // Flicker controller for tube light effect
    _flickerController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Glow controller for stabilization
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Subtitle fade in controller
    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Pulse controller for continuous subtle animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    // Text opacity animation (flicker effect)
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
           CurvedAnimation(parent: _flickerController, curve: Curves.easeIn),
    );

    // Text glow animation (increases on stabilization)
    _textGlow = Tween<double>(
      begin: 10.0,
      end: 50.0,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeOut));

    // Subtitle opacity animation
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _subtitleController, curve: Curves.easeInOut),
    );

    // Pulse animation for subtle breathing effect
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  // Play the sparkle sound
  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/sparkle.wav'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
          }
  }

  void _startSplashSequence() async {
    // Phase 0: Initial darkness (0-2 seconds)
    await Future.delayed(const Duration(milliseconds: 2000));

    // Phase 1: First flicker (quick on/off)
    setState(() => _flickerPhase = 1);
    _flickerController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _flickerController.reverse();
    await Future.delayed(const Duration(milliseconds: 180));

    // Phase 2: Second flicker (slightly longer and brighter)
    setState(() => _flickerPhase = 2);
    _flickerController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _flickerController.reverse();
    await Future.delayed(const Duration(milliseconds: 220));

    // Phase 3: Final stabilization - tube light fully on with intense glow
    setState(() => _flickerPhase = 3);
    _flickerController.forward();
    _glowController.forward();
    await Future.delayed(const Duration(milliseconds: 1800));

    // Phase 4: Subtitle fade in (after text stabilizes)
    _subtitleController.forward();

    // *** NEW — Navigate to Login screen after full sequence ***
    await Future.delayed(const Duration(seconds: 2)); // Keep subtitle visible
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _flickerController.dispose();
    _glowController.dispose();
    _subtitleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Pure black background
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _flickerController,
          _glowController,
          _subtitleController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _flickerPhase == 3 ? _pulseAnimation.value : 1.0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTubeLightText(),
                  const SizedBox(height: 32),
                  _buildSubtitle(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTubeLightText() {
    double currentOpacity = 0.0;
    double currentGlow = 0.0;
    Color glowColor = const Color(0xFFFFD700);

    if (_flickerPhase == 0) {
      currentOpacity = 0.0;
      currentGlow = 0.0;
    } else if (_flickerPhase == 1) {
      currentOpacity = _textOpacity.value * 0.35;
      currentGlow = 12.0;
    } else if (_flickerPhase == 2) {
      currentOpacity = _textOpacity.value * 0.65;
      currentGlow = 20.0;
    } else if (_flickerPhase == 3) {
      currentOpacity = _textOpacity.value;
      currentGlow = _textGlow.value;
    }

    return AnimatedOpacity(
      opacity: currentOpacity,
      duration: const Duration(milliseconds: 80),
      child: Stack(
        children: [
          Transform.translate(
            offset: const Offset(6, 8),
            child: Text(
              'Codfofun',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..color = Colors.black.withOpacity(0.8),
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(3, 4),
            child: Text(
              'Codfofun',
              style: TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..color = Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Text(
            'Codfofun',
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.w900,
              letterSpacing: 4.0,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: currentGlow * 1.5,
                  color: glowColor.withOpacity(0.8),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: currentGlow * 1.2,
                  color: glowColor.withOpacity(0.9),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: currentGlow * 0.8,
                  color: const Color(0xFFFFEB3B).withOpacity(1.0),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: currentGlow * 0.5,
                  color: const Color(0xFFFFEB3B).withOpacity(1.0),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: currentGlow * 0.3,
                  color: Colors.white,
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: currentGlow * 0.15,
                  color: Colors.white,
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: currentGlow * 0.6,
                  color: const Color(0xFFFF9800).withOpacity(0.7),
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return AnimatedOpacity(
      opacity: _subtitleOpacity.value,
      duration: const Duration(milliseconds: 100),
      child: Stack(
        children: [
          Transform.translate(
            offset: const Offset(2, 3),
            child: Text(
              'Welcome to Code Cult',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 4.0,
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..color = Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          Text(
            'Welcome to Code Cult',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: 4.0,
              color: const Color(0xFF00E5FF),
              shadows: [
                Shadow(
                  blurRadius: 30,
                  color: const Color(0xFF00E5FF).withOpacity(0.8),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 20,
                  color: const Color(0xFF00E5FF),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 15,
                  color: const Color(0xFF00E5FF),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 8,
                  color: Colors.white.withOpacity(0.6),
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 25,
                  color: const Color(0xFF9C27B0).withOpacity(0.4),
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
