import 'package:flutter/material.dart';
import 'booking_screen.dart'; 

class DoctorDetailsScreen extends StatelessWidget {
  final String name;
  final String specialty;
  final String imageUrl;

  const DoctorDetailsScreen({
    super.key,
    required this.name,
    required this.specialty,
    required this.imageUrl,
  });

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
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blueAccent,
                backgroundImage: NetworkImage(imageUrl),
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(doctorName: name),
                    ),
                  );
                },
                child: const Text(
                  'Proceed to Booking',
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