import 'package:flutter/material.dart';
import 'package:poll_application/Providers/auth_provider.dart';

import 'package:poll_application/Screens/splash_screen.dart';
import 'package:poll_application/Styles/colors.dart';
import 'package:poll_application/Utils/message.dart';
import 'package:poll_application/Utils/router.dart';

class AccountsPage extends StatefulWidget {
  const AccountsPage({super.key});

  @override
  State<AccountsPage> createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            AuthProvider().logout().then((value) {
              if (value == false) {
                error(context, message: "Please try again");
              } else {
                nextPageRemoveUntil(context, const SplashScreen());
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
              'Log out',
            ),
          ),
        ),
      ),
    );
  }
}