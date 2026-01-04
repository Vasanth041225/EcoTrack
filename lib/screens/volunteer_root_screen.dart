import 'package:flutter/material.dart';
import 'package:vas_flutter/screens/chat_screen.dart';
import 'dashboard_volunteer.dart';
import 'settings.dart';

class VolunteerRootScreen extends StatefulWidget {
  const VolunteerRootScreen({super.key});

  @override
  State<VolunteerRootScreen> createState() => _VolunteerRootScreenState();
}

class _VolunteerRootScreenState extends State<VolunteerRootScreen> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    VolunteerDashboard(),
    ChatScreen(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: pages[_currentIndex],
      ),

      // ===== BOTTOM NAV =====
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            elevation: 0,
            backgroundColor: Colors.transparent,
            type: BottomNavigationBarType.fixed,

            selectedItemColor: Colors.green.shade600,
            unselectedItemColor:
                isDark ? Colors.white60 : Colors.grey.shade600,

            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 11),

            onTap: (index) {
              setState(() => _currentIndex = index);
            },

            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: "Dashboard",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.smart_toy_outlined),
                activeIcon: Icon(Icons.smart_toy),
                label: "AI",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
