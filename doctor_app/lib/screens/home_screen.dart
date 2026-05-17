import 'package:doctor_app/providers/widgets/doctor_shimmer_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/appointment_provider.dart';

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
    {'name': 'Dr. Amal Silva', 'specialty': 'Cardiology', 'hospital': 'Asiri Hospital', 'imagePath': 'assets/images/doc4.png', 'rating': '4.9', 'price': 'Rs. 2500'},
    {'name': 'Dr. Nimali Perera', 'specialty': 'Dentist', 'hospital': 'Nawaloka Hospital', 'imagePath': 'assets/images/doc2.png', 'rating': '4.8', 'price': 'Rs. 2000'},
    {'name': 'Dr. Kamal Fernando', 'specialty': 'Pediatrics', 'hospital': 'Lanka Hospitals', 'imagePath': 'assets/images/doc3.png', 'rating': '4.7', 'price': 'Rs. 3000'},
    {'name': 'Dr. Ruwanthi Dias', 'specialty': 'Dermatology', 'hospital': 'Hemas Hospital', 'imagePath': 'assets/images/doc1.png', 'rating': '4.9', 'price': 'Rs. 2800'},
    {'name': 'Dr. Sanath Jayasuriya', 'specialty': 'Neurology', 'hospital': 'Asiri Hospital', 'imagePath': 'assets/images/doc3.png', 'rating': '4.6', 'price': 'Rs. 3500'},
  ];

  @override
  void initState() {
    super.initState();
    // පිටුව ලෝඩ් වෙද්දීම Database එකෙන් ළඟම තියෙන Appointment එක අදින්න කියනවා
    Future.microtask(() =>
        Provider.of<AppointmentProvider>(context, listen: false).fetchUpcomingAppointment());
  }

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
            // 1. උඩින්ම තියෙන Header එක (Search Bar එකත් එක්ක)
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
                          const Text('Let\'s find your Doctor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
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
            const SizedBox(height: 14),

            // 2. Upcoming Appointment Card (Database එකෙන් දත්ත අරන් පෙන්වන කොටස)
            Consumer<AppointmentProvider>(
              builder: (context, appointProvider, child) {
                if (appointProvider.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: LinearProgressIndicator(color: Colors.teal),
                  );
                }

                final appointment = appointProvider.upcomingAppointment;
                // ඉදිරි Appointment එකක් නැත්නම් මේ Card එක පෙන්වන්නේ නැහැ
                if (appointment == null) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.stars, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text('Upcoming Appointment', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25, backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(Icons.person, color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(appointment['doctor_name'] ?? 'Doctor Name', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(appointment['doctor_specialty'] ?? 'Specialty', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(appointment['appointment_date'] ?? 'Date', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text(appointment['appointment_time'] ?? 'Time', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // 3. Specialties (විශේෂඥතාවයන්)
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

            // 4. Choose Hospital (රෝහල තේරීම)
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

            // 5. Doctors List (තෝරාගත් රෝහලට අදාළ වෛද්‍යවරු)
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

            // 🌟 Loading වෙන වෙලාවට Shimmer Effect එක පෙන්වන කොටස
            Consumer<AppointmentProvider>(
              builder: (context, appointProvider, child) {
                // ඇප් එක දත්ත අදින ගමන් (Loading) නම් Shimmer එක පෙන්වනවා
                if (appointProvider.isLoading) {
                  return  DoctorShimmerLoading();
                }

                // දත්ත ලෝඩ් වෙලා ඉවර නම් සාමාන්‍ය විදිහට ලිස්ට් එක පෙන්වනවා
                return filteredDoctors.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(child: Text('No doctors available in this hospital right now.', style: TextStyle(color: Colors.grey[500]), textAlign: TextAlign.center)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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