import 'package:flutter/material.dart';
import 'package:poll_application/Providers/auth_provider.dart';
import 'package:poll_application/Screens/main_activity_page.dart';
import 'package:poll_application/Styles/colors.dart';
import 'package:poll_application/Utils/message.dart';
import 'package:poll_application/Utils/router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            AuthProvider().signInWithGoogle().then((value) {
              if (value.user == null) {
                error(context, message: "Please try again");
              } else {
                nextPageRemoveUntil(context, const MainActivityPage());
              }
            });
          },
          child: Container(
            height: 50,
            width: 345,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Text(
              'Login',
            ),
          ),
        ),
      ),
    );
  }
}
