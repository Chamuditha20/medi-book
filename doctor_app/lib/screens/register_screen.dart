import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // 👈 අලුත් Controller එක
  
  bool _isLoading = false;
  bool _obscurePassword = true; // 👈 Password එක හංගන්න/පෙන්වන්න
  bool _obscureConfirmPassword = true; // 👈 Confirm Password එක හංගන්න/පෙන්වන්න

  Future<void> _register() async {
    // 1. ඔක්කොම කොටු පුරවලද බලනවා
    if (_nameController.text.trim().isEmpty || 
        _emailController.text.trim().isEmpty || 
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields!'), backgroundColor: Colors.red));
      return;
    }

    // 2. Password දෙක සමානද කියලා බලනවා (👈 අලුතින් එකතු කළා)
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match!'), backgroundColor: Colors.redAccent));
      return;
    }

    // 3. Password එකට අකුරු/ඉලක්කම් 6ක් වත් තියෙනවද බලනවා
    if (_passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password must be at least 6 characters!'), backgroundColor: Colors.orange));
      return;
    }

    setState(() { _isLoading = true; });

    final success = await Provider.of<AuthProvider>(context, listen: false).signUp(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nameController.text.trim(),
    );

    setState(() { _isLoading = false; });

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account Created Successfully! '), backgroundColor: Colors.green));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Failed. Try a different email.'), backgroundColor: Colors.red));
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
              const SizedBox(height: 10),
              Center(child: Image.asset('assets/images/register_illustration.png', height: 180)),
              const SizedBox(height: 20),
              Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
              const SizedBox(height: 8),
              Text('Sign up to book your appointments easily.', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
              const SizedBox(height: 30),

              // Full Name Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: TextField(controller: _nameController, style: TextStyle(color: textColor), decoration: InputDecoration(border: InputBorder.none, icon: const Icon(Icons.person, color: Colors.teal), hintText: 'Full Name', hintStyle: TextStyle(color: Colors.grey[400]))),
              ),
              const SizedBox(height: 16),

              // Email Field
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: TextField(controller: _emailController, style: TextStyle(color: textColor), keyboardType: TextInputType.emailAddress, decoration: InputDecoration(border: InputBorder.none, icon: const Icon(Icons.email, color: Colors.teal), hintText: 'Email Address', hintStyle: TextStyle(color: Colors.grey[400]))),
              ),
              const SizedBox(height: 16),

              // Password Field (Show/Hide Icon එකත් එක්ක)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: TextField(
                  controller: _passwordController, 
                  style: TextStyle(color: textColor), 
                  obscureText: _obscurePassword, // 👈 වෙනස් වෙන අගය
                  decoration: InputDecoration(
                    border: InputBorder.none, 
                    icon: const Icon(Icons.lock, color: Colors.teal), 
                    hintText: 'Password (min 6 chars)', 
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    // 👈 අලුත් Eye Icon එක
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () {
                        setState(() { _obscurePassword = !_obscurePassword; });
                      },
                    ),
                  )
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password Field (Show/Hide Icon එකත් එක්ක)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: TextField(
                  controller: _confirmPasswordController, 
                  style: TextStyle(color: textColor), 
                  obscureText: _obscureConfirmPassword, // 👈 වෙනස් වෙන අගය
                  decoration: InputDecoration(
                    border: InputBorder.none, 
                    icon: const Icon(Icons.lock_outline, color: Colors.teal), 
                    hintText: 'Confirm Password', 
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    // 👈 අලුත් Eye Icon එක
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () {
                        setState(() { _obscureConfirmPassword = !_obscureConfirmPassword; });
                      },
                    ),
                  )
                ),
              ),
              const SizedBox(height: 30),

              // Register Button
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),

              // Go to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ", style: TextStyle(color: Colors.grey[500])),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                    child: const Text('Login', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}