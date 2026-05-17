import 'package:flutter/material.dart';
import 'doctor_details_screen.dart';
import 'specialty_doctors_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // දැනට තෝරලා තියෙන රෝහල
  String _selectedHospital = 'All';

  final List<String> hospitals = [
    'All',
    'Asiri Hospital',
    'Nawaloka Hospital',
    'Lanka Hospitals',
    'Hemas Hospital'
  ];

  final List<Map<String, dynamic>> specialties = [
    {'name': 'Cardiology', 'icon': Icons.favorite, 'color': const Color(0xFFFF4D4D)},
    {'name': 'Pediatrics', 'icon': Icons.child_care, 'color': const Color(0xFFFF9F43)},
    {'name': 'Neurology', 'icon': Icons.psychology, 'color': const Color(0xFF9B5DE5)},
    {'name': 'Orthopedics', 'icon': Icons.accessibility, 'color': const Color(0xFF00BBF9)},
    {'name': 'Dermatology', 'icon': Icons.clean_hands, 'color': const Color(0xFFF15BB5)},
  ];

  final List<Map<String, String>> doctors = [
    {'name': 'Dr. Amal Silva', 'specialty': 'Cardiology', 'hospital': 'Asiri Hospital', 'imagePath': 'assets/images/doc1.png', 'rating': '4.9', 'price': 'Rs. 2500'},
    {'name': 'Dr. Nimali Perera', 'specialty': 'Dentist', 'hospital': 'Nawaloka Hospital', 'imagePath': 'assets/images/doc2.png', 'rating': '4.8', 'price': 'Rs. 2000'},
    {'name': 'Dr. Kamal Fernando', 'specialty': 'Pediatrics', 'hospital': 'Lanka Hospitals', 'imagePath': 'assets/images/doc3.png', 'rating': '4.7', 'price': 'Rs. 3000'},
    {'name': 'Dr. Ruwanthi Dias', 'specialty': 'Dermatology', 'hospital': 'Hemas Hospital', 'imagePath': 'assets/images/doc4.png', 'rating': '4.9', 'price': 'Rs. 2800'},
    {'name': 'Dr. Sanath Jayasuriya', 'specialty': 'Neurology', 'hospital': 'Asiri Hospital', 'imagePath': 'assets/images/doc1.png', 'rating': '4.6', 'price': 'Rs. 3500'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3E50);
    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final scaffoldBg = isDark ? const Color(0xFF121212) : const Color(0xFFF0F4F8);

    // තෝරාගත් රෝහලට අනුව වෛද්‍යවරුන්ව පෙරා ගැනීම (Filtering)
    final filteredDoctors = _selectedHospital == 'All' 
        ? doctors 
        : doctors.where((doc) => doc['hospital'] == _selectedHospital).toList();

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. උඩින්ම තියෙන Header එක
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark ? [const Color(0xFF0D5C53), const Color(0xFF1A1A1A)] : [const Color(0xFF0F766E), const Color(0xFF115E59)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(36), bottomRight: Radius.circular(36)),
                boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome Back,', style: TextStyle(fontSize: 14, color: Colors.white70, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text('Let\'s find your Doctor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.notifications_none, color: Colors.white))
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(color: isDark ? Colors.grey[900] : Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
                    child: TextField(style: TextStyle(color: textColor), decoration: InputDecoration(hintText: 'Search doctors, hospitals...', hintStyle: TextStyle(color: Colors.grey[400]), border: InputBorder.none, icon: const Icon(Icons.search, color: Colors.teal))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 2. Specialties (උඩින්ම පෙන්වනවා)
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0), child: Text('Specialties', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: textColor))),
            const SizedBox(height: 14),
            SizedBox(
              height: 100,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                itemCount: specialties.length,
                itemBuilder: (context, index) {
                  final spec = specialties[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SpecialtyDoctorsScreen(specialtyName: spec['name'])));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 22),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [spec['color'].withOpacity(0.2), spec['color'].withOpacity(0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                              borderRadius: BorderRadius.circular(20), border: Border.all(color: spec['color'].withOpacity(0.3), width: 1),
                            ),
                            child: Icon(spec['icon'], color: spec['color'], size: 28),
                          ),
                          const SizedBox(height: 8),
                          Text(spec['name'], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.grey[400] : const Color(0xFF4A5568))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // 3. Select Hospital (රෝහල තේරීම)
            Padding(padding: const EdgeInsets.symmetric(horizontal: 20.0), child: Text('Choose Hospital', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: textColor))),
            const SizedBox(height: 12),
            SizedBox(
              height: 45,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                itemCount: hospitals.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedHospital == hospitals[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() { _selectedHospital = hospitals[index]; });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : (isDark ? Colors.grey[800] : Colors.white),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? Colors.teal : Colors.grey.withOpacity(0.3)),
                        boxShadow: isSelected ? [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
                      ),
                      child: Center(
                        child: Text(
                          hospitals[index],
                          style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : (isDark ? Colors.grey[300] : Colors.grey[700])),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // 4. Doctors List (තෝරාගත් රෝහලට අදාළ වෛද්‍යවරු)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedHospital == 'All' ? 'All Doctors' : 'Doctors at $_selectedHospital', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: textColor)),
                  Text('${filteredDoctors.length} found', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            
            filteredDoctors.isEmpty 
              ? Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Center(child: Text('No doctors available in this hospital right now.', style: TextStyle(color: Colors.grey[500]), textAlign: TextAlign.center)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const NeverScrollableScrollPhysics(), // Scroll වෙන්නේ ප්‍රධාන පිටුව විතරයි
                  shrinkWrap: true, // ListView එකට අවශ්‍ය ඉඩ විතරක් ගන්නවා
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDoctors[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetailsScreen(name: doc['name']!, specialty: doc['specialty']!, imagePath: doc['imagePath']!)));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cardColor, borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 80, height: 80,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.teal.withOpacity(0.1), image: DecorationImage(image: AssetImage(doc['imagePath']!), fit: BoxFit.cover)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(doc['name']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                                  const SizedBox(height: 4),
                                  Text('${doc['specialty']} | ${doc['hospital']}', style: TextStyle(fontSize: 13, color: Colors.grey[500])),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(children: [const Icon(Icons.star, color: Colors.amber, size: 16), const SizedBox(width: 4), Text(doc['rating']!, style: const TextStyle(fontWeight: FontWeight.bold))]),
                                      Text(doc['price']!, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}