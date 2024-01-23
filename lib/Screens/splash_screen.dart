import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poll_application/Screens/Authenticatin/auth_page.dart';
import 'package:poll_application/Screens/individual_poll.dart';
import 'package:poll_application/Screens/main_activity_page.dart';
import 'package:poll_application/Utils/dynamic_utils.dart';
import 'package:poll_application/Utils/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  void navigate() {
    Future.delayed(const Duration(seconds: 3), () {
      if (user == null) {
        nextPage(context, const AuthPage());
      } else {
        DynamicLinkProvider().initDynamicLink().then((value) {
          if (value == "") {
            nextPageRemoveUntil(context, const MainActivityPage());
          } else {
            nextPage(context, IndividualPollPage(id: value));
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 90,
          child: Image.asset('assets/logos/Logo.png'),
        ),
      ),
    );
  }
}
