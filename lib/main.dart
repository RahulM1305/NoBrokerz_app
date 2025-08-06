import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nobrokerz_app/resident/resident_home.dart';
import 'package:nobrokerz_app/splash_screen.dart';
import 'auth/login_screen.dart';
import 'auth/security_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visitor Approval App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: Colors.transparent,
      ),
      home: SplashScreen(), // use this directly while testing
    );
  }
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _sliderTimer;

  final List<_Feature> features = [
    _Feature(
      icon: Icons.flash_on,
      title: "Fast Approvals",
      subtitle: "Approve or reject visitors instantly.",
    ),
    _Feature(
      icon: Icons.verified_user,
      title: "Secure Login",
      subtitle: "Roles are separated and secured.",
    ),
    _Feature(
      icon: Icons.notifications_active,
      title: "Instant Alerts",
      subtitle: "Get notified of visitor activity in real-time.",
    ),
    _Feature(
      icon: Icons.shield,
      title: "Guard Dashboard",
      subtitle: "Easy access and tracking for security.",
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoSlide();
    });
  }

  void _startAutoSlide() {
    _sliderTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % features.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE3F2FD), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Feature Carousel (expanded to take available space)
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: features.length,
                  itemBuilder: (context, index) {
                    final feature = features[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFBBDEFB), Color(0xFFE3F2FD)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(feature.icon, size: 60,
                                  color: Colors.blueAccent),
                              const SizedBox(height: 20),
                              Text(
                                feature.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                feature.subtitle,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Role Selection Section
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RoleCard(
                      title: 'Resident',
                      icon: Icons.person,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (
                              context) => const ResidentLoginScreen()),
                        );
                      },
                    ),
                    RoleCard(
                      title: 'Security',
                      icon: Icons.security,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (
                              context) => const SecurityLoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


  class RoleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blueAccent),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String subtitle;

  _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
