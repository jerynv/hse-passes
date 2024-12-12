import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hse_apps/widgets/theme_toggle.dart'; // Import for iOS-style widgets

class UserTab extends StatefulWidget {
  final bool isDarkMode; // Optional: Pass initial theme state
  final VoidCallback toggleTheme; // Optional: Pass theme toggle callback

  const UserTab({this.isDarkMode = false, required this.toggleTheme});

  @override
  State<UserTab> createState() => UsertabState();
}

class UsertabState extends State<UserTab> {
  bool isDarkMode = false; // State variable for theme (optional)
  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode; // Use passed value or default
  }

  @override
  Widget build(BuildContext context) {
    // Leverage platform channels for platform-specific styling (optional)
    final brightness = Theme.of(context).brightness;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Information (adapt to your use case)
              Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage(
                        'assets/logo.png'), // Replace with your asset path
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'admin', // Replace with actual username
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Theme Toggle (adapt to your toggleTheme logic)
              //horizantally aling text end to end with a cupertino switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Light/Dark Mode',
                    style: TextStyle(
                      fontSize: 18,
                      color: brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    onPressed: _toggleTheme,
                  ),
                ],
              ),

              //divider
              Divider(
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
                thickness: 0.5,
                height: 40,
              ),

              // Account Management (replace with your actions)
              CupertinoListTile(
                title: Text('Terms and Conditions'),
                trailing: Icon(CupertinoIcons.right_chevron),
                onTap: () {
                  // Handle account management navigation
                },
              ),

              CupertinoListTile(
                title: Text('Privacy Policy'),
                trailing: Icon(CupertinoIcons.right_chevron),
                onTap: () {
                  // Handle account management navigation
                },
              ),

              CupertinoListTile(
                title: Text('About'),
                trailing: Icon(CupertinoIcons.right_chevron),
                onTap: () {
                  // Handle account management navigation
                },
              ),

              CupertinoListTile(
                title: Text('Rate Us'),
                trailing: Icon(CupertinoIcons.right_chevron),
                onTap: () {
                  //rateing popup
                },
              ),

              CupertinoListTile(
                title: Text('Report a Bug'),
                trailing: Icon(CupertinoIcons.right_chevron),
                onTap: () {
                  // Handle account management navigation
                },
              ),

              Divider(
                color:
                    brightness == Brightness.dark ? Colors.white : Colors.black,
                thickness: 0.2,
                height: 40,
              ),

              CupertinoListTile(
                title: Text('Change Email'),
                trailing: Icon(CupertinoIcons.right_chevron),
                onTap: () {
                  // Handle account management navigation
                },
              ),

              CupertinoListTile(
                title: Text('Reset Password'),
                trailing: Icon(CupertinoIcons.right_chevron),
                onTap: () {
                  // Handle account management navigation
                },
              ),

              CupertinoListTile(
                title: Text('Logout'),
                trailing: Icon(CupertinoIcons.power),
                onTap: () {
                  //send to login page

                  Navigator.pushNamed(context, '/login');

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
