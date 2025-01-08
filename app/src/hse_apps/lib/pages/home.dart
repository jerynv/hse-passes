import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:bottom_navbar_with_indicator/bottom_navbar_with_indicator.dart';
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
    const PassesTab(),
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
      body: Column(
        children: [
          // Spacer bar
          Container(
            height: 10, // Height of the spacer bar
            color: Colors.grey.withOpacity(0.5), // Spacer bar color
          ),
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(0),
        color: Brightness.dark == Theme.of(context).brightness
            ? Colors.black
            : Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: double.infinity,
              height: 2,
              decoration: BoxDecoration(
                color: Brightness.dark == Theme.of(context).brightness
                    ? Colors.grey.withOpacity(0.5)
                    : Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
              child: GNav(
                tabBackgroundColor: Colors.blueAccent.withOpacity(.2),
                tabBorderRadius: 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                gap: 8,
                tabs: _navButtons.map((navButton) {
                  return _buildNavButton(
                    navButton.icon,
                    navButton.text,
                    navButton.index,
                  );
                }).toList(),
                selectedIndex: _currentIndex,
                onTabChange: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  GButton _buildNavButton(IconData icon, String text, int index) {
    return GButton(
      icon: icon,
      text: text,
      
    );
  }
}

class navButton {
  final IconData icon;
  final String text;
  final int index;

  navButton({required this.icon, required this.text, required this.index});
}
