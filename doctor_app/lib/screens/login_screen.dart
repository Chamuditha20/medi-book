import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Email and Password!'), backgroundColor: Colors.red));
      return;
    }

    setState(() { _isLoading = true; });

    // AuthProvider හරහා ලොග් වෙන්න උත්සාහ කරනවා
    final success = await Provider.of<AuthProvider>(context, listen: false).signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() { _isLoading = false; });

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Welcome Back! 👋'), backgroundColor: Colors.teal));
      // සාර්ථක නම් MainScreen එකට යනවා
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Email or Password.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3E50);
    final cardColor = isDark ? Colors.grey[850] : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Center(child: Image.asset('assets/images/login_illustration.png', height: 220)),
              const SizedBox(height: 40),
              Text('Welcome Back!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 8),
              Text('Login to access your appointments.', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
              const SizedBox(height: 30),

              // Email Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: TextField(controller: _emailController, style: TextStyle(color: textColor), keyboardType: TextInputType.emailAddress, decoration: InputDecoration(border: InputBorder.none, icon: const Icon(Icons.email, color: Colors.teal), hintText: 'Email Address', hintStyle: TextStyle(color: Colors.grey[400]))),
              ),
              const SizedBox(height: 16),

              // Password Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: TextField(controller: _passwordController, style: TextStyle(color: textColor), obscureText: true, decoration: InputDecoration(border: InputBorder.none, icon: const Icon(Icons.lock, color: Colors.teal), hintText: 'Password', hintStyle: TextStyle(color: Colors.grey[400]))),
              ),
              const SizedBox(height: 40),

              // Login Button
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // Go to Register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? ", style: TextStyle(color: Colors.grey[500])),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                    child: const Text('Sign Up', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
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