import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic>? _upcomingAppointment;
  bool _isLoading = false;

  Map<String, dynamic>? get upcomingAppointment => _upcomingAppointment;
  bool get isLoading => _isLoading;

  // Database එකෙන් ළඟම තියෙන එක Appointment එකක් විතරක් ගන්නවා
  Future<void> fetchUpcomingAppointment() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // ලොග් වුණු කෙනාගේ ඉදිරි Appointment එකක් විතරක් අදිනවා
      final response = await _supabase
          .from('appointments')
          .select()
          .eq('user_id', userId)
          .order('appointment_date', ascending: true) // ළඟම දිනය මුලට ගන්නවා
          .limit(1) // එකක් විතරක් ගන්නවා
          .maybeSingle(); // දත්ත නැත්නම් Null දෙනවා, Error වෙන්නේ නැහැ

      _upcomingAppointment = response;
    } catch (e) {
      debugPrint("🔴 Appointment Fetch Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}