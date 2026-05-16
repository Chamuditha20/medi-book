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

// ---------------------------------------------------------
// දෙවන පිටුව: වෛද්‍යවරයාගේ විස්තර (Doctor Details Screen)
// ---------------------------------------------------------
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
                  backgroundColor: Colors.blue[800], // පාට නිල් කළා
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // දැන් මේ බොත්තම එබුවම අලුත් Booking Screen එකට යනවා
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(doctorName: name),
                    ),
                  );
                },
                child: const Text(
                  'Proceed to Booking', // නම වෙනස් කළා
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

// ---------------------------------------------------------
// තුන්වන පිටුව: Appointment වෙන්කරගැනීමේ පෝරමය (Booking Form Screen)
// ---------------------------------------------------------
class BookingScreen extends StatefulWidget {
  final String doctorName;

  const BookingScreen({super.key, required this.doctorName});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // ෆෝම් එකේ දත්ත තියාගන්න Controller සහ විචල්‍යයන්
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  DateTime? selectedDate;
  String? selectedTime;
  
  // වෛද්‍යවරයා ඉන්න වෙලාවන් ලැයිස්තුව
  final List<String> timeSlots = ['09:00 AM', '11:00 AM', '02:00 PM', '05:00 PM', '07:00 PM'];

  // දින දර්ශනය (Calendar) පෙන්නන Function එක
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // අදට කලින් දවස් තෝරන්න බැරි වෙන්න
      lastDate: DateTime(2027),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // කීබෝඩ් එක එද්දී Scroll වෙන්න මේක දානවා
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking for: ${widget.doctorName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            const SizedBox(height: 24),
            
            // රෝගියාගේ නම
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Patient Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            
            // දුරකථන අංකය
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 24),

            // දිනය තෝරාගැනීම
            const Text('Select Date:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate == null 
                          ? 'Choose a date' 
                          : '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
                      style: TextStyle(fontSize: 16, color: selectedDate == null ? Colors.grey[600] : Colors.black),
                    ),
                    const Icon(Icons.calendar_today, color: Colors.blueAccent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // වේලාව තෝරාගැනීම (Dropdown)
            const Text('Select Time Slot:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text('Choose a time'),
                  value: selectedTime,
                  items: timeSlots.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedTime = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Confirm බොත්තම
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // සරල Validation එකක් (තොරතුරු ඔක්කොම දීලද බලන්න)
                  if (nameController.text.isEmpty || selectedDate == null || selectedTime == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please fill all details and select date/time')),
                    );
                    return;
                  }

                  // සාර්ථක පණිවිඩය පෙන්වීම
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Appointment Booked Successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );

                  // තත්පර 1කට පස්සේ මුල් පිටුවටම ආපසු යැවීම
                  Future.delayed(const Duration(seconds: 1), () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  });
                },
                child: const Text(
                  'Confirm & Book',
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