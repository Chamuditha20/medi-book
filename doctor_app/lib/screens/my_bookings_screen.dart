import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // පිටුව ලෝඩ් වෙද්දීම Supabase එකෙන් දත්ත අදින්න (Fetch) කියනවා
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    await Provider.of<BookingProvider>(context, listen: false).fetchBookings();
    if (mounted) {
      setState(() { _isLoading = false; }); // දත්ත ආවම Loading එක නවත්වනවා
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3E50);
    
    // Provider එකේ තියෙන Bookings ලැයිස්තුව ගන්නවා
    final bookings = Provider.of<BookingProvider>(context).bookings;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('My Bookings', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal)) // Loading සලකුණ
          : bookings.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/booking_illustration.png', height: 200, fit: BoxFit.contain),
                        const SizedBox(height: 24),
                        Text('No bookings yet!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 8),
                        Text('Your booked appointments will appear here.', style: TextStyle(fontSize: 15, color: Colors.grey[500])),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.white, 
                        borderRadius: BorderRadius.circular(16), 
                        boxShadow: [BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12), 
                            decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), shape: BoxShape.circle), 
                            child: const Icon(Icons.medical_services, color: Colors.teal)
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(booking.doctorName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                                const SizedBox(height: 4),
                                Text('${booking.date} | ${booking.time}', style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.w600, fontSize: 13)),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.person, size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(booking.patientName, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.phone, size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(booking.phoneNumber, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                                  ],
                                ),
                              ],
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