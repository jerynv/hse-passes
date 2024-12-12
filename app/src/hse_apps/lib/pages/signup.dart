import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hse_apps/pages/login.dart';
import 'dart:async';

class SignupPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignupPage> {
  bool isTermsChecked = false;
  bool isDarkMode = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
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
    final studentID = _studentIDController.text;
    final password = _passwordController.text;
    final passwordConfirm = _passwordController.text;

    if (email == 'admin' && password == 'pass') {
      // ignore: use_build_context_synchronously
      //rout to /home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } else {
      setState(() {
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
                duration: Duration(milliseconds: 1000),
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
                                _isSigningIn = false;
                              });
                            },
                            child: Text('Back to Login'),
                          ),
                        ],
                      )
                    : //text saying loading and a circular progress indicator
                      
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text(
                              'Creating Account',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 20,

                              ),
                            ),
                            SizedBox(height: 20),
                            CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          ],
                        )
                      
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
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _studentIDController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            isDarkMode ? Colors.grey[850] : Colors.grey[200],
                        hintText: 'Student ID',
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
                    TextField(
                      controller: _passwordConfirmController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor:
                            isDarkMode ? Colors.grey[850] : Colors.grey[200],
                        hintText: 'Confirm Password',
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
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 230),
                            child: Text(
                              'By signing up, you agree to our Terms of Service and Privacy Policy',
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.grey : Colors.black54,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                              textWidthBasis: TextWidthBasis.longestLine,
                            ),
                          ),
                        ),
                        Checkbox(
                          value: isTermsChecked,
                          activeColor: Colors.blueAccent,
                          onChanged: (bool? value) {
                            setState(() {
                              isTermsChecked = value!; // Update the state
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                              color: isDarkMode ? Colors.grey : Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Login',
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
    _passwordConfirmController.dispose();
    _studentIDController.dispose();
    super.dispose();
  }
}

//error screen with buttton and error message

// import 'package:flutter/material.dart';
// import 'home.dart';
// import 'dart:async';
