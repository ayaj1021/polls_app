import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poll_application/Providers/auth_provider.dart';
import 'package:poll_application/Providers/bottom_nav_provider.dart';
import 'package:poll_application/Providers/db_provider.dart';
import 'package:poll_application/Providers/fetch_poll_provider.dart';
import 'package:poll_application/Screens/splash_screen.dart';
import 'package:poll_application/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => BottomNavProvider()),
        ChangeNotifierProvider(create: (context) => DbProvider()),
        ChangeNotifierProvider(create: (context) => FetchPollsProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
