import 'package:flutter/material.dart';
import 'package:hse_apps/pages/signup.dart';
import 'package:hse_apps/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSigningIn = false;
  bool _loginFailed = false;
  bool _can_login = false;

  Future<void> _login() async {
    setState(() {
      _isSigningIn = true;
      _loginFailed = false;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulate server delay

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email == 'admin' && password == 'pass') {
      // ignore: use_build_context_synchronously
      //rout to /home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
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
    final brightness = Theme.of(context).brightness;
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      _can_login = true;
      print("object");
    } else {
      _can_login = false;
    }
    return Scaffold(
      backgroundColor:
          brightness == Brightness.dark ? Colors.black : Colors.grey[100],
      body: Center(
        child: _isSigningIn
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: _loginFailed
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 80,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Login Failed',
                            style: TextStyle(
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 210),
                            child: Text(
                              'Incorrect email or password. Please try again.',
                              style: TextStyle(
                                color: brightness == Brightness.dark
                                    ? Colors.grey
                                    : Colors.black54,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              onPressed: () {
                                setState(() {
                                  _loginFailed = false;
                                  _isSigningIn = false;
                                });
                              },
                              child: const Text('Back',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            ),
                          )
                        ],
                      )
                    : //text saying loading and a circular progress indicator

                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'logging in',
                            style: TextStyle(
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const CircularProgressIndicator(
                            color: Colors.blueAccent,
                          ),
                        ],
                      ))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            brightness == Brightness.dark
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            color: brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black,
                          ),
                          onPressed: () {
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme();
                          },
                        ),
                      ],
                    ),
                    const Text(
                      'Hse Passes',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please sign in to continue',
                      style: TextStyle(
                        color: brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _emailController,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.grey[200],
                        hintText: 'Email/Id',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: brightness == Brightness.dark
                            ? Colors.grey[850]
                            : Colors.grey[200],
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _can_login
                          ? _login
                          : null, // Disable button when _can_login is false
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _can_login ? Colors.blueAccent : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Navigate to password recovery
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                              color: brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black54),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to sign up
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SignupPage(),
                              ),
                            );
                          },
                          child: const Text(
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
  void initState() {
    super.initState();

    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
  }

  void _validateInputs() {
    setState(() {
      _can_login = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateInputs);
    _passwordController.removeListener(_validateInputs);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

//error screen with buttton and error message

// import 'package:flutter/material.dart';
// import 'home.dart';
// import 'dart:async';
