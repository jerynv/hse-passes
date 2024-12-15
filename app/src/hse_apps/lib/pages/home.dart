import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
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
    UserTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: _pages[_currentIndex],
        ),
        // line to separate the bottom navigation bar from the bod
        
        bottomNavigationBar: Padding(
          
          padding: const EdgeInsets.all(10),
          child: GNav(
            tabBackgroundColor: Colors.blueAccent.withOpacity(.2),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical:10),
            tabs: [
              GButton(
                icon: Icons.home,
                text: '  Passes',
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              GButton(
                icon: Icons.add_box_rounded,
                text: '  Requests',
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
              GButton(
                icon: Icons.settings,
                text: '  Settings',
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
