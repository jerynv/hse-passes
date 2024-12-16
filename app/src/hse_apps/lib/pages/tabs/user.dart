import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hse_apps/pages/login.dart';
import 'package:hse_apps/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => UsertabState();
}

class UsertabState extends State<UserTab> {
  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return CupertinoPageScaffold(
      backgroundColor: brightness == Brightness.dark
          ? Colors.black
          : Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30.0,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'admin',
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    ListTile(
                      title: const Text('Light/Dark Mode'),
                      trailing: Icon(
                        brightness == Brightness.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onTap: () {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                    ),
                    Divider(
                      color: brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      thickness: 0.5,
                      height: 40,
                    ),
                    ListTile(
                      title: const Text('Terms and Conditions'),
                      trailing: const Icon(Icons.arrow_circle_right_outlined),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Privacy Policy'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('About'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Rate Us'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Report a Bug'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    Divider(
                      color: brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      thickness: 0.2,
                      height: 40,
                    ),
                    ListTile(
                      title: const Text('Change Email'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Reset Password'),
                      trailing: const Icon(Icons.keyboard_arrow_right),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text('Logout'),
                      trailing: const Icon(Icons.logout),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
