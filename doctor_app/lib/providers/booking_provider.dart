import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];
  final _supabase = Supabase.instance.client;

  List<Booking> get bookings => _bookings;

  // 1. Booking එකක් දාද්දී ලොග් වෙලා ඉන්න කෙනාගේ ID එකත් සමඟ සේව් කිරීම
  Future<bool> addBooking(Booking booking) async {
    try {
      // 👈 දැනට ලොග් වෙලා ඉන්න පරිශීලකයාගේ සුවිශේෂී ID එක ගන්නවා
      final currentUserId = _supabase.auth.currentUser?.id; 

      await _supabase.from('bookings').insert({
        'user_id': currentUserId, // 👈 Database එකේ අලුත් column එකට මේ ID එක දානවා
        'doctor_name': booking.doctorName,
        'patient_name': booking.patientName,
        'phone_number': booking.phoneNumber,
        'date': booking.date,
        'time': booking.time,
      });

      await fetchBookings(); 
      return true;
    } catch (error) {
      debugPrint("🔴 SUPABASE INSERT ERROR: $error");
      return false;
    }
  }

  // 2. ලොග් වෙලා ඉන්න කෙනාගේ Bookings විතරක් පෙරා ගැනීම (Filter)
  Future<void> fetchBookings() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id; 
      
      if (currentUserId == null) return;

      // 👈 .eq('user_id', currentUserId) මඟින් ලොග් වුණු කෙනාගේ දත්ත විතරක්ම ලබාගන්නවා
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('user_id', currentUserId)
          .order('date', ascending: true);
      
      _bookings = response.map((item) => Booking(
        id: item['id'].toString(),
        userId: item['user_id'], // 👈 Model එකට දානවා
        doctorName: item['doctor_name'],
        patientName: item['patient_name'],
        phoneNumber: item['phone_number'] ?? 'No Number', 
        date: item['date'],
        time: item['time'],
      )).toList();
      
      notifyListeners(); 
    } catch (error) {
      debugPrint("🔴 SUPABASE FETCH ERROR: $error");
    }
  }

  // 3. Booking එකක් Cancel කිරීම
  Future<bool> cancelBooking(String id) async {
    try {
      await _supabase.from('bookings').delete().eq('id', id);
      await fetchBookings(); 
      return true;
    } catch (error) {
      debugPrint("🔴 SUPABASE DELETE ERROR: $error");
      return false;
    }
  }
}