import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    await Provider.of<BookingProvider>(context, listen: false).fetchBookings();
    if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  // 👈 Cancel කරන්න කලින් අහන කොටුව (Confirmation Dialog)
  void _showCancelConfirmation(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Cancel Booking?'),
          ],
        ),
        content: const Text('Are you sure you want to cancel this appointment? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(), // එපා (No) කිව්වොත් කොටුව වැහෙනවා
            child: Text('Keep It', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              Navigator.of(ctx).pop(); // මුලින්ම කොටුව වහනවා
              setState(() { _isLoading = true; }); // Loading පෙන්වනවා
              
              // Provider එක හරහා Database එකෙන් මකනවා
              final success = await Provider.of<BookingProvider>(context, listen: false).cancelBooking(bookingId);
              
              setState(() { _isLoading = false; }); // Loading නවත්වනවා
              
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking Cancelled Successfully!'), backgroundColor: Colors.orange));
              }
            },
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2C3E50);
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
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : bookings.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_today, size: 80, color: Colors.teal),
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
                          // 👈 අලුත් Cancel බොත්තම (Delete Icon)
                          IconButton(
                            icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 28),
                            onPressed: () {
                              if (booking.id != null) {
                                _showCancelConfirmation(context, booking.id!);
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}