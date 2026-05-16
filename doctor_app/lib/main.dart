import 'package:flutter/material.dart';

void main() {
  runApp(const DoctorApp());
}

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Channeling',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const HomeScreen(),
    );
  }
}

// ---------------------------------------------------------
// පළමු පිටුව: වෛද්‍යවරුන්ගේ ලැයිස්තුව (Home Screen)
// ---------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ව්‍යාජ වෛද්‍යවරුන්ගේ ලැයිස්තුවක් (Dummy Data)
    final List<Map<String, String>> doctors = [
      {'name': 'Dr. Amal Silva', 'specialty': 'Cardiologist (හෘද රෝග)'},
      {'name': 'Dr. Nimali Perera', 'specialty': 'Dentist (දන්ත)'},
      {'name': 'Dr. Kamal Fernando', 'specialty': 'Pediatrician (ළමා රෝග)'},
      {'name': 'Dr. Ruwanthi Dias', 'specialty': 'Dermatologist (චර්ම රෝග)'},
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
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
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
                          // Book බොත්තම එබූ විට Details Screen එකට යාම
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorDetailsScreen(
                                name: doctors[index]['name']!,
                                specialty: doctors[index]['specialty']!,
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

// ---------------------------------------------------------
// දෙවන පිටුව: වෛද්‍යවරයාගේ විස්තර (Doctor Details Screen)
// ---------------------------------------------------------
class DoctorDetailsScreen extends StatelessWidget {
  final String name;
  final String specialty;

  const DoctorDetailsScreen({super.key, required this.name, required this.specialty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Details'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              specialty,
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            const Text(
              'About Doctor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'මෙම වෛද්‍යවරයා වසර 10කට වැඩි පළපුරුද්දක් ඇති විශේෂඥයෙකි. ඔබගේ සෞඛ්‍ය ගැටලු සඳහා කාරුණිකව සහ වගකීමෙන් යුතුව ප්‍රතිකාර කරනු ඇත.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(), // මේකෙන් යට තියෙන බොත්තම තිරයේ පහළටම තල්ලු කරනවා
            SizedBox(
              width: double.infinity, // බොත්තම තිරය පුරාවට දික් කරන්න
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // Confirm බොත්තම එබූ විට සාර්ථක බව පෙන්වන පණිවිඩය (SnackBar)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Appointment Booked Successfully!',
                        style: TextStyle(fontSize: 16),
                      ),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                    ),
                  );
                  
                  // තත්පරයකට පස්සේ ආපහු මුල් පිටුවට යන්න (අවශ්‍ය නම්)
                  // Future.delayed(const Duration(seconds: 1), () {
                  //   Navigator.pop(context);
                  // });
                },
                child: const Text(
                  'Confirm Appointment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}