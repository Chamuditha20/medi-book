import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class RecordProvider with ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get records => _records;
  bool get isLoading => _isLoading;

  // 1. Database එකෙන් රෝගියාගේ වාර්තා ටික අරගන්නවා
  Future<void> fetchRecords() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('records')
          .select()
          .eq('user_id', userId)
          .order('id', ascending: false);

      _records = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("🔴 Fetch Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 2. අලුත් ෆොටෝ එකක් Storage එකට දාලා Database එකට Save කරනවා
  Future<bool> uploadRecord(String title, XFile imageFile) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      // ෆොටෝ එක Bytes බවට පත් කරනවා (Web එකට වැඩ කරන්න)
      final Uint8List bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.name.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      final filePath = '${user.id}/$fileName'; // කෙනාගේ ID එකෙන් ෆෝල්ඩරයක් හදනවා

      // Storage එකට Upload කිරීම
      await _supabase.storage.from('medical_records').uploadBinary(
        filePath,
        bytes,
        fileOptions: FileOptions(contentType: 'image/$fileExt'),
      );

      // Public URL එක ගැනීම
      final imageUrl = _supabase.storage.from('medical_records').getPublicUrl(filePath);

      // Database එකට විස්තර දැමීම
      await _supabase.from('records').insert({
        'user_id': user.id,
        'title': title,
        'image_url': imageUrl,
      });

      await fetchRecords(); // අලුත් වාර්තාවත් එක්ක ලැයිස්තුව Refresh කරනවා
      return true;
    } catch (e) {
      debugPrint("🔴 Upload Error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}