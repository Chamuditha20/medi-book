import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import '../models/booking.dart';

class DoctorDetailsScreen extends StatefulWidget {
  final String name;
  final String specialty;
  final String imagePath;

  const DoctorDetailsScreen({
    super.key,
    required this.name,
    required this.specialty,
    required this.imagePath,
  });

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime.now(), 
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) { 
        return Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Colors.teal)), child: child!); 
      },
    );
    if (picked != null) {
      setState(() { _selectedDate = picked; });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context, 
      initialTime: TimeOfDay.now(),
      builder: (context, child) { 
        return Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: Colors.teal)), child: child!); 
      },
    );
    if (picked != null) {
      setState(() { _selectedTime = picked; });
    }
  }

  Future<void> _confirmBooking() async {
    // ෆෝම් එකේ ඔක්කොම පුරවලද බලනවා (Phone Number එකත් ඇතුළුව)
    if (_patientNameController.text.trim().isEmpty || 
        _phoneController.text.trim().isEmpty || 
        _selectedDate == null || 
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the details!'), backgroundColor: Colors.redAccent)
      );
      return;
    }

    setState(() { _isLoading = true; });

    // Model එකට දත්ත ටික දානවා
    final newBooking = Booking(
      doctorName: widget.name,
      patientName: _patientNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      date: "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}",
      time: _selectedTime!.format(context),
    );

    // Provider හරහා Supabase එකට යවනවා
    final success = await Provider.of<BookingProvider>(context, listen: false).addBooking(newBooking);

    setState(() { _isLoading = false; });

    // සාර්ථක නම් පණිවිඩයක් දීලා ආපහු යනවා
    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Successfully! '), backgroundColor: Colors.green, duration: Duration(seconds: 3))
      );
      Navigator.pop(context); 
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Failed! Please try again.'), backgroundColor: Colors.red)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3E50);
    final cardColor = isDark ? Colors.grey[850] : Colors.white;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: IconThemeData(color: textColor), 
        title: Text('Doctor Details', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), 
        centerTitle: true
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Hero(
                tag: widget.name, 
                child: Container(
                  width: 140, height: 140, 
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.teal.withOpacity(0.3), width: 3), image: DecorationImage(image: AssetImage(widget.imagePath), fit: BoxFit.cover))
                )
              )
            ),
            const SizedBox(height: 20),
            Center(child: Text(widget.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor))),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), 
                decoration: BoxDecoration(color: Colors.teal.withOpacity(0.15), borderRadius: BorderRadius.circular(20)), 
                child: Text(widget.specialty, style: const TextStyle(fontSize: 15, color: Colors.teal, fontWeight: FontWeight.bold))
              )
            ),
            const SizedBox(height: 30),

            Text('Book Appointment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 16),
            
            // Patient Name Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
              child: TextField(
                controller: _patientNameController, 
                style: TextStyle(color: textColor),
                decoration: InputDecoration(border: InputBorder.none, icon: const Icon(Icons.person, color: Colors.teal), hintText: 'Enter Patient Name', hintStyle: TextStyle(color: Colors.grey[400])),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
              child: TextField(
                controller: _phoneController, 
                style: TextStyle(color: textColor),
                keyboardType: TextInputType.phone, 
                decoration: InputDecoration(border: InputBorder.none, icon: const Icon(Icons.phone, color: Colors.teal), hintText: 'Enter Phone Number', hintStyle: TextStyle(color: Colors.grey[400])),
              ),
            ),
            const SizedBox(height: 16),

            // Date Picker Field
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.teal), 
                    const SizedBox(width: 16), 
                    Text(_selectedDate == null ? 'Select Appointment Date' : "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}", style: TextStyle(color: _selectedDate == null ? Colors.grey[500] : textColor, fontSize: 16))
                  ]
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Picker Field
            GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.teal), 
                    const SizedBox(width: 16), 
                    Text(_selectedTime == null ? 'Select Appointment Time' : _selectedTime!.format(context), style: TextStyle(color: _selectedTime == null ? Colors.grey[500] : textColor, fontSize: 16))
                  ]
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Confirm Booking Button
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 5),
                onPressed: _isLoading ? null : _confirmBooking,
                child: _isLoading 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : const Text('Confirm Booking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}