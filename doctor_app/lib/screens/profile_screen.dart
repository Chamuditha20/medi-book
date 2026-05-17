import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart'; // Dark Mode එකට අදාළ Provider එක
import 'login_screen.dart';
import 'medical_records_screen.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;
  String _name = 'Loading...';
  String _email = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // පිටුව ලෝඩ් වෙද්දීම දත්ත අදින්න කියනවා
  }

  // Database එකේ 'users' table එකෙන් නම සහ ඊමේල් එක ගන්නවා
  Future<void> _fetchUserData() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user != null) {
        final response = await _supabase
            .from('users')
            .select()
            .eq('user_id', user.id)
            .single(); 

        if (mounted) {
          setState(() {
            _name = response['name'] ?? 'No Name';
            _email = response['email'] ?? 'No Email';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("🔴 ERROR FETCHING PROFILE: $e");
      if (mounted) {
        setState(() {
          _name = 'User';
          _email = 'user@example.com';
          _isLoading = false;
        });
      }
    }
  }

  // App එකෙන් ඉවත් වෙන (Log Out) Function එක
  Future<void> _logout() async {
    await Provider.of<AuthProvider>(context, listen: false).signOut();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3E50);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('My Profile', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // ලස්සන Profile පින්තූරයක් (නමේ මුල් අකුරෙන්)
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.teal.withOpacity(0.2),
                    child: Text(
                      _name.isNotEmpty ? _name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // නම සහ ඊමේල් එක
                  Text(_name, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Text(_email, style: TextStyle(fontSize: 16, color: Colors.grey[500])),
                  
                  const SizedBox(height: 40),
                  ListTile(
                  leading: const Icon(Icons.folder_special, color: Colors.teal),
                   title: const Text('My Medical Records', style: TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => const MedicalRecordsScreen()));
                  },
),
                  // 👈 Dark Mode Switch එක
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                    ),
                    child: SwitchListTile(
                      title: Text('Dark Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                      secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.teal),
                      activeColor: Colors.teal,
                      value: Provider.of<ThemeProvider>(context).isDarkMode,
                      onChanged: (value) {
                        final provider = Provider.of<ThemeProvider>(context, listen: false);
                        provider.toggleTheme(value);
                      },
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Log Out බොත්තම
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.logout, color: Colors.white, size: 24),
                      label: const Text('Log Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      onPressed: _logout, 
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}