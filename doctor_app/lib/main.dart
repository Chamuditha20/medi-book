import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/booking_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart'; // 👈 අලුතින් එකතු කළා
import 'screens/login_screen.dart';
import 'providers/record_provider.dart';
import 'providers/appointment_provider.dart';
// ... (ඔයාගේ Supabase Initialize කරන කෑල්ල එහෙම්මම තියන්න)

class DoctorApp extends StatelessWidget {
  const DoctorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 👈 Theme Provider එකට කතා කරනවා
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor App',
      themeMode: themeProvider.themeMode, // 👈 Switch එකට අනුව Mode එක මාරු වෙනවා
      
      // Light Theme (සුදු පාට තිරය)
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF0F4F8),
      ),
      
      // Dark Theme (කළු පාට තිරය)
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      
      home: const LoginScreen(), 
    );
  }
}

// 👈 MultiProvider එක ඇතුලට ThemeProvider එකත් දාන්න
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await Supabase.initialize(
    // 👇 මම අකුරු හරියටම නිවැරදි කරපු ලින්ක් එක
    url: 'https://dehjzfyynypjoftcotza.supabase.co', 
    
    // 👇 ඔයාගේ හරිම Key එක
    anonKey: 'sb_publishable_H-1WapypM1Ve1TgZdfs1_g_iRp8l99D', 
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
        ChangeNotifierProvider(create: (_) => RecordProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),// 👈 අලුතින් එකතු කළා
      ],
      child: const DoctorApp(),
    ),
  );
}