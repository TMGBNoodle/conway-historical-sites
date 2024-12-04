import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:faulkner_footsteps/app_router.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  void _handleContinue() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      AppRouter.navigateTo(context, AppRouter.list);
    } else {
      AppRouter.navigateTo(context, AppRouter.loginPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB97A57),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/testLogo.png',
                width: 400, // Adjust the size as needed
                height: 400,
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _handleContinue,
              child: const Text('Continue'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), // Adjust button size as needed
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => AppRouter.navigateTo(context, AppRouter.loginPage),
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50), // Adjust button size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}