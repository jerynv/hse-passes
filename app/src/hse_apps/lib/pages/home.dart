import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'tabs/request.dart';
import 'tabs/passes.dart';
import 'tabs/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    PassesTab(),
    const RequestsTab(),
    const UserTab(),
  ];

  final List<navButton> _navButtons = [
    navButton(icon: Icons.home, text: '  Passes', index: 0),
    navButton(icon: Icons.add_box_outlined, text: '  Requests', index: 1),
    navButton(icon: Icons.account_circle, text: '  User', index: 2),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: GNav(
          tabBackgroundColor: Colors.blueAccent.withOpacity(.2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          tabs: _navButtons.map((navButton) {
            return _buildNavButton(navButton.icon, navButton.text, navButton.index);
          }).toList(), // Convert Iterable to List
        ),
      ),
    );
  }

  GButton _buildNavButton(IconData icon, String text, int index) {
    return GButton(
      icon: icon,
      text: text,
      onPressed: () {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}

class navButton {
  final IconData icon;
  final String text;
  final int index;

  navButton({required this.icon, required this.text, required this.index});
}
