import 'package:flutter/material.dart';
import 'package:poll_application/Providers/bottom_nav_provider.dart';
import 'package:poll_application/Screens/BottomNavPages/Account/accounts_page.dart';
import 'package:poll_application/Screens/BottomNavPages/Home/home_page.dart';
import 'package:poll_application/Screens/BottomNavPages/MyPolls/my_polls.dart';
import 'package:provider/provider.dart';

class MainActivityPage extends StatefulWidget {
  const MainActivityPage({super.key});

  @override
  State<MainActivityPage> createState() => _MainActivityPageState();
}

class _MainActivityPageState extends State<MainActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
        builder: (context, bottomNavProvider, child) {
      return Scaffold(
        body: _pages[bottomNavProvider.currentindex],
        bottomNavigationBar: BottomNavigationBar(
          items: _items,
          currentIndex: bottomNavProvider.currentindex,
          onTap: (value) {
            bottomNavProvider.changeIndex = value;
          },
        ),
      );
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const MyPollPage(),
    const AccountsPage()
  ];

  final List<BottomNavigationBarItem> _items = [
    const BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
    const BottomNavigationBarItem(icon: Icon(Icons.poll), label: "My polls"),
    const BottomNavigationBarItem(icon: Icon(Icons.person), label: "Accounts"),
  ];
}
