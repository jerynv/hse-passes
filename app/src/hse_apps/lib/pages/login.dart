import 'package:flutter/material.dart';
import 'package:hse_apps/pages/signup.dart';
import 'home.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isDarkMode = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;
  bool _loginFailed = false;

  void _toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  Future<void> _login() async {
    setState(() {
      _isSigningIn = true;
      _loginFailed = false;
    });

    await Future.delayed(Duration(seconds: 2)); // Simulate server delay

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email == 'admin' && password == 'pass') {
      // ignore: use_build_context_synchronously
      //rout to /home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      setState(() {
        _isSigningIn = false;
        _loginFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: _isSigningIn
            ? AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _loginFailed
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 80,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Login Failed',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Invalid credentials. Please try again.',
                            style: TextStyle(
                              color: isDarkMode ? Colors.grey : Colors.black54,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _loginFailed = false;
                              });
                            },
                            child: Text('Back to Login'),
                          ),
                        ],
                      )
                    : CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          onPressed: _toggleTheme,
                        ),
                      ],
                    ),
                    Text(
                      'Hse Passes',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Please sign in to continue',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey : Colors.black54,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            isDarkMode ? Colors.grey[850] : Colors.grey[200],
                        hintText: 'Email/Id',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            isDarkMode ? Colors.grey[850] : Colors.grey[200],
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Navigate to password recovery
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: isDarkMode ? Colors.grey : Colors.black54),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: isDarkMode ? Colors.grey : Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to sign up
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SignupPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

//error screen with buttton and error message

// import 'package:flutter/material.dart';
// import 'home.dart';
// import 'dart:async';
