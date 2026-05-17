import 'package:flutter/material.dart';

class PersonalDetailsScreen extends StatelessWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3E50);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Personal Details', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Picture with Edit Icon
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.teal, width: 3),
                      image: const DecorationImage(image: NetworkImage('https://randomuser.me/api/portraits/men/32.jpg'), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.teal, shape: BoxShape.circle, border: Border.all(color: Theme.of(context).scaffoldBackgroundColor, width: 2)),
                      child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Editable Text Fields
            _buildTextField('Full Name', 'sumeera', Icons.person_outline, isDark),
            const SizedBox(height: 16),
            _buildTextField('Email', 'sumeera@email.com', Icons.email_outlined, isDark),
            const SizedBox(height: 16),
            _buildTextField('Phone Number', '+94 77 123 4567', Icons.phone_outlined, isDark),
            const SizedBox(height: 16),
            _buildTextField('Date of Birth', '01 Jan 2000', Icons.calendar_today, isDark),
            const SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated Successfully!'), backgroundColor: Colors.teal));
                  Navigator.pop(context); // Go back to profile screen after saving
                },
                child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Re-usable Input Field for this screen
  Widget _buildTextField(String label, String initialValue, IconData icon, bool isDark) {
    return TextFormField(
      initialValue: initialValue,
      style: TextStyle(color: isDark ? Colors.white : const Color(0xFF2C3E50), fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: Colors.teal),
        fillColor: isDark ? Colors.grey[850] : Colors.white,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.teal, width: 2)),
      ),
    );
  }
}