import 'package:flutter/material.dart';
import 'doctor_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> doctors = [
      {
        'name': 'Dr. Amal Silva',
        'specialty': 'Cardiologist (හෘද රෝග)',
        'imageUrl': 'https://randomuser.me/api/portraits/men/11.jpg'
      },
      {
        'name': 'Dr. Nimali Perera',
        'specialty': 'Dentist (දන්ත)',
        'imageUrl': 'https://randomuser.me/api/portraits/women/44.jpg'
      },
      {
        'name': 'Dr. Kamal Fernando',
        'specialty': 'Pediatrician (ළමා රෝග)',
        'imageUrl': 'https://randomuser.me/api/portraits/men/33.jpg'
      },
      {
        'name': 'Dr. Ruwanthi Dias',
        'specialty': 'Dermatologist (චර්ම රෝග)',
        'imageUrl': 'https://randomuser.me/api/portraits/women/68.jpg'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Doctor'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Doctors',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blueAccent,
                        backgroundImage: NetworkImage(doctors[index]['imageUrl']!),
                      ),
                      title: Text(
                        doctors[index]['name']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(doctors[index]['specialty']!),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[800],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDetailsScreen(
                                name: doctors[index]['name']!,
                                specialty: doctors[index]['specialty']!,
                                imageUrl: doctors[index]['imageUrl']!,
                              ),
                            ),
                          );
                        },
                        child: const Text('Book'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}