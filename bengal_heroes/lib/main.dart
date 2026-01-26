import 'package:flutter/material.dart';

void main() {
  runApp(const BengalHeroesApp());
}

class BengalHeroesApp extends StatelessWidget {
  const BengalHeroesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bengal Heroes',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Serif',
      ),
      home: const LandingScreen(),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/bengal_bg.jpg',
            fit: BoxFit.cover,
          ),

          // Dark overlay for readability
          Container(
            color: Colors.black.withOpacity(0.6),
          ),

          // Animated Text
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bengal Heroes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: Colors.amber.shade200,
                        shadows: const [
                          Shadow(
                            blurRadius: 12,
                            color: Colors.black,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tales of Legends',
                      style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 2,
                        color: Colors.amber.shade100.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
