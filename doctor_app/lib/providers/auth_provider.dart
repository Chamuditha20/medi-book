import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  User? _user;

  User? get user => _user ?? _supabase.auth.currentUser;

  // 1. අලුතින් ලියාපදිංචි වීම (Sign Up + Database Save)
  Future<bool> signUp(String email, String password, String name) async {
    try {
      // 1. Auth එකේ Register කරනවා (Email & Password)
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      // 2. ඒක සාර්ථක නම්, අපේ අලුත් 'users' table එකට විස්තර ටික දානවා
      if (response.user != null) {
        await _supabase.from('users').insert({
          'user_id': response.user!.id, // Supabase එකෙන් දෙන විශේෂ ID එක
          'name': name,
          'email': email,
        });

        _user = response.user;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("SIGNUP DB ERROR: $e");
      return false;
    }
  }

  // 2. ලොග් වීම (Sign In)
  Future<bool> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _user = response.user;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("LOGIN ERROR: $e");
      return false;
    }
  }

  // 3. ඉවත් වීම (Sign Out)
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _user = null;
    notifyListeners();
  }
}