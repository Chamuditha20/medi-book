class Booking {
  final String? id; 
  final String? userId; // 👈 අලුතින් එකතු කළා
  final String doctorName;
  final String patientName;
  final String phoneNumber; 
  final String date;
  final String time;

  Booking({
    this.id, 
    this.userId, // 👈 අලුතින් එකතු කළා
    required this.doctorName,
    required this.patientName,
    required this.phoneNumber,
    required this.date,
    required this.time,
  });
}