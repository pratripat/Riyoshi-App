import 'package:flutter/material.dart';
import 'package:myapp/pages/homePage.dart';
import 'package:myapp/services/authService.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const PasswordField({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 30,
      child: TextField(
        controller: widget.controller,
        cursorColor: Colors.white,
        cursorHeight: 15,
        style: TextStyle(color: Colors.grey),
        obscureText: _isObscured,
        onSubmitted: (_) => widget.onSubmit(),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          hintText: 'password',
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isObscured ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
              size: 16,
            ),
            onPressed: () {
              setState(() {
                _isObscured = !_isObscured;
              });
            },
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
    return emailRegex.hasMatch(email.trim());
  }

  bool _isValidPassword(String password) {
    return password.isNotEmpty;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 32, 32, 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (!_isValidEmail(email) && !_isValidPassword(password)) {
      _showErrorDialog('Email or password is incorrect.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorDialog('Invalid email');
      return;
    }

    if (!_isValidPassword(password)) {
      _showErrorDialog('Password cannot be empty');
      return;
    }

    setState(() => _isLoading = true);

    final success = await AuthService.login(email, password);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      _showErrorDialog('Invalid email or password.');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.6), // top left area
            radius: 1.2,
            colors: [
              Color(0xFF3b0764), // deep purple
              Color(0xFF1a0533), // dark violet
              Color(0xFF0a0010), // near black
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/images/logo.png', width: 300),
              Text(
                'Sign in to access the account area',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 24),

              Container(
                width: 300,
                height: 30,
                child: TextField(
                  controller: _emailController,
                  cursorColor: Colors.white,
                  cursorHeight: 15,
                  style: TextStyle(color: Colors.grey),
                  keyboardType: TextInputType.emailAddress,
                  onSubmitted: (_) => _handleSubmit(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.black,
                    hintText: 'email',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              PasswordField(
                controller: _passwordController,
                onSubmit: _handleSubmit,
              ),

              const SizedBox(height: 16),

              Container(
                width: 300,
                height: 30,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 103, 105, 109),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Continue',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 208, 208, 208),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Forgot password? -',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Reset',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
