import 'package:flutter/material.dart';
import 'package:hse_apps/pages/Tlogin.dart';
import 'package:hse_apps/pages/home.dart';
import 'package:hse_apps/pages/landing.dart';
import 'package:hse_apps/pages/signup.dart';
import 'package:hse_apps/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'pages/login.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(ChangeNotifierProvider<ThemeProvider>(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hse Passes',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: {
        '/home': (context) => const  HomePage(),
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/teacherLogin': (context) => const TeacherLoginPage(),
        '/': (context) => const LandingPage(),
      },
    );
  }
}
