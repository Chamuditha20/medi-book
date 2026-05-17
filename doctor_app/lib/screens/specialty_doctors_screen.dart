import 'package:flutter/material.dart';
import 'doctor_details_screen.dart';

class SpecialtyDoctorsScreen extends StatelessWidget {
  final String specialtyName;

  const SpecialtyDoctorsScreen({super.key, required this.specialtyName});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3E50);

    // මුළු Doctor ලැයිස්තුවම (Home එකේ තියෙන එකමයි)
    final List<Map<String, String>> allDoctors = [
      {'name': 'Dr. Amal Silva', 'specialty': 'Cardiology', 'hospital': 'Asiri Hospital', 'imagePath': 'assets/images/doc1.png', 'rating': '4.9'},
      {'name': 'Dr. Nimali Perera', 'specialty': 'Dentist', 'hospital': 'Nawaloka Hospital', 'imagePath': 'assets/images/doc2.png', 'rating': '4.8'},
      {'name': 'Dr. Kamal Fernando', 'specialty': 'Pediatrics', 'hospital': 'Lanka Hospitals', 'imagePath': 'assets/images/doc3.png', 'rating': '4.7'},
      {'name': 'Dr. Ruwanthi Dias', 'specialty': 'Dermatology', 'hospital': 'Hemash Hospital', 'imagePath': 'assets/images/doc4.png', 'rating': '4.9'},
    ];

    // Click කරපු Specialty එකට අදාල Doctor ලාව විතරක් Filter කරලා ගන්නවා
    final filteredDoctors = allDoctors.where((doc) => doc['specialty'] == specialtyName).toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('$specialtyName Specialists', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        centerTitle: true,
      ),
      body: filteredDoctors.isEmpty
          ? Center(
              child: Text('No doctors available for $specialtyName right now.', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doc = filteredDoctors[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Row(
                    children: [
                      Hero(
                        tag: doc['name']!,
                        child: Container(
                          width: 70, height: 70,
                          decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage(doc['imagePath']!), fit: BoxFit.cover)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(doc['name']!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                            const SizedBox(height: 4),
                            Text(doc['hospital']!, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(12)),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetailsScreen(name: doc['name']!, specialty: doc['specialty']!, imagePath: doc['imagePath']!)));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}