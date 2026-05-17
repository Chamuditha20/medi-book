import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'booking_screen.dart'; 
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const BookingScreen(), 
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Scaffold එක ඇතුලටම පිටු යන නිසා Navigation Bar එක උඩින් පාවෙන්න Stack එකක් දානවා
      body: Stack(
        children: [
          _pages[_selectedIndex],
          
          // 🌟 මෙන්න මෙතන ඉඳන් තමයි Custom Floating Navigation Bar එක හැදෙන්නේ
          Positioned(
            left: 20,
            right: 20,
            bottom: 24, // ස්ක්‍රීන් එකේ පල්ලෙහා ඉඳන් තියෙන පරතරය
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(28), // වටකුරු දාර
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10), // පාවෙන පෙනුම දෙන සෙවනැල්ල
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home', isDark),
                  _buildNavItem(1, Icons.library_books_outlined, Icons.library_books, 'Bookings', isDark),
                  _buildNavItem(2, Icons.person_outline, Icons.person, 'Profile', isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // එක එක අයිකන් එක සහ ඒක ක්ලික් වෙද්දී වෙනස් වෙන හැටි හදන උදව් පදවිය (Widget Builder)
  Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label, bool isDark) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // තෝරාගත් Icon එක ලස්සනට උඩට ඉස්සෙන සහ පාට වෙනස් වෙන කොටස
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(0, isSelected ? -4 : 0, 0), // ටිකක් උඩට ඉස්සීම
              child: Icon(
                isSelected ? selectedIcon : unselectedIcon,
                color: isSelected ? Colors.teal : (isDark ? Colors.grey[400] : Colors.grey[500]),
                size: isSelected ? 28 : 24,
              ),
            ),
            const SizedBox(height: 4),
            // ලේබල් එක (Text එක)
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.teal : (isDark ? Colors.grey[400] : Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}