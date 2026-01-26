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
        fontFamily: 'Serif', // Using a classic font for historical feel
        colorScheme: ColorScheme.dark(
          primary: Colors.amber.shade700,
          onPrimary: Colors.black,
          secondary: Colors.amber.shade400,
          onSecondary: Colors.black,
          surface: Colors.grey.shade900,
          onSurface: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          error: Colors.red.shade700,
          onError: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade700, // Historical gold tone
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              fontFamily: 'Serif',
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.amber.shade700,
          foregroundColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
          ),
        ),
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
      duration: const Duration(milliseconds: 1800), // Slightly longer duration for a grander feel
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOut), // Fade in slightly slower
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic), // Slide in after a slight delay
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToMainAppScreen() {
    Navigator.of(context).pushReplacement<void, void>(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => const MainAppScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/bengal_bg.jpg',
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              );
            },
            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
              return Container(
                color: Theme.of(context).colorScheme.surface,
                child: Icon(Icons.broken_image, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), size: 80),
              );
            },
          ),

          // Dark gradient overlay for readability and aesthetic
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const <double>[0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Animated Text and Button
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Bengal Heroes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 52, // Increased font size for grandeur
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          color: Colors.amber.shade200,
                          shadows: <Shadow>[
                            Shadow(
                              blurRadius: 16,
                              color: Colors.black.withOpacity(0.7),
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20), // Increased spacing
                      Text(
                        'Chronicles of Valor', // Changed subtitle for a more epic feel
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22, // Increased font size
                          letterSpacing: 2.5,
                          color: Colors.amber.shade100.withOpacity(0.9),
                          fontStyle: FontStyle.italic,
                          shadows: <Shadow>[
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 60), // Space before the button
                      ElevatedButton.icon(
                        onPressed: _navigateToMainAppScreen,
                        icon: const Icon(Icons.arrow_forward_ios),
                        label: const Text('Begin Journey'), // Descriptive button text
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for the main application screen after "Get Started"
class MainAppScreen extends StatelessWidget {
  const MainAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Heroic Saga'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome, Adventurer!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(height: 20),
              Text(
                'Your journey through history begins now. Prepare for tales of courage and triumph.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop(); // Go back to the landing screen
                },
                icon: const Icon(Icons.undo),
                label: const Text('Return to Landing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}