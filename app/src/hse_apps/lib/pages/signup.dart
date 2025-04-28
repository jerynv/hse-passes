import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hse_apps/pages/login.dart';

import 'package:provider/provider.dart';
import 'package:hse_apps/theme/theme_provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _studentIDController = TextEditingController();
  bool _isSigningIn = false;
  bool _loginFailed = false;
  bool _can_signup = false;
  bool isTermsChecked = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateInputs);
    _passwordController.addListener(_validateInputs);
    _passwordConfirmController.addListener(_validateInputs);
    _studentIDController.addListener(_validateInputs);
  }

  void _validateInputs() {
    setState(() {
      _can_signup = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordConfirmController.text.isNotEmpty &&
          _studentIDController.text.isNotEmpty &&
          isTermsChecked &&
          _passwordController.text == _passwordConfirmController.text;
    });
  }

  Future<void> _signup() async {
    setState(() {
      _isSigningIn = true;
      _loginFailed = false;
    });

    await Future.delayed(const Duration(seconds: 2)); // Simulate server delay

    final email = _emailController.text;
    final studentID = _studentIDController.text;
    final password = _passwordController.text;

    if (email == 'admin' && studentID == '123456' && password == 'pass') {
    } else {
      setState(() {
        _loginFailed = true;
        _isSigningIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
      ),
      backgroundColor:
          brightness == Brightness.dark ? Colors.black : Colors.white,
      body: Center(
        child: _isSigningIn
            ? _buildLoadingState(brightness)
            : _buildSignupForm(brightness),
      ),
    );
  }

  Widget _buildLoadingState(Brightness brightness) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Creating Account...',
          style: TextStyle(
            color: brightness == Brightness.dark ? Colors.white : Colors.black,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 20),
        const CircularProgressIndicator(color: Colors.blueAccent),
      ],
    );
  }

  Widget _buildSignupForm(Brightness brightness) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildThemeToggle(brightness),
          _buildHeader(brightness),
          const SizedBox(height: 40),
          _buildTextField(_emailController, 'Email', brightness),
          const SizedBox(height: 20),
          _buildTextField(_studentIDController, 'Student ID', brightness),
          const SizedBox(height: 20),
          _buildTextField(_passwordController, 'Password', brightness,
              isPassword: true),
          const SizedBox(height: 20),
          _buildTextField(
              _passwordConfirmController, 'Confirm Password', brightness,
              isPassword: true),
          const SizedBox(height: 20),
          _buildSignupButton(),
          const SizedBox(height: 20),
          _buildTermsCheckbox(brightness),
          const SizedBox(height: 20),
          _buildLoginLink(brightness),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(Brightness brightness) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(
            brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode,
            color: brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
          },
        ),
      ],
    );
  }

  Widget _buildHeader(Brightness brightness) {
    return Column(
      children: [
        const Text(
          'Hse Passes',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Create an account to continue',
          style: TextStyle(
            color: brightness == Brightness.dark ? Colors.grey : Colors.black54,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, Brightness brightness,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      textAlign: TextAlign.center,
      style: TextStyle(
          color: brightness == Brightness.dark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor:
            brightness == Brightness.dark ? Colors.grey[850] : Colors.grey[200],
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSignupButton() {
    return ElevatedButton(
      onPressed: _can_signup ? _signup : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _can_signup ? Colors.blueAccent : Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildTermsCheckbox(Brightness brightness) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            'By signing up, you agree to our Terms of Service and Privacy Policy',
            style: TextStyle(
              color:
                  brightness == Brightness.dark ? Colors.grey : Colors.black54,
              fontSize: 14,
            ),
          ),
        ),
        Checkbox(
          value: isTermsChecked,
          activeColor: Colors.blueAccent,
          onChanged: (bool? value) {
            setState(() {
              isTermsChecked = value ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildLoginLink(Brightness brightness) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: brightness == Brightness.dark ? Colors.grey : Colors.black54,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text(
            'Login',
            style: TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
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
