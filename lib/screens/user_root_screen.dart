import 'package:flutter/material.dart';
import 'package:vas_flutter/screens/chat_screen.dart';
import 'dashboard_user.dart';
import 'settings.dart';


class CitizenRootScreen extends StatefulWidget {
  const CitizenRootScreen({super.key});

  @override
  State<CitizenRootScreen> createState() => _CitizenRootScreenState();
}

class _CitizenRootScreenState extends State<CitizenRootScreen> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    CitizenDashboard(),
    ChatScreen(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: pages[_currentIndex],

      // ===== BOTTOM NAV BAR =====
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F1F1F) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (i) => setState(() => _currentIndex = i),
                type: BottomNavigationBarType.fixed,
                elevation: 0,

                backgroundColor:
                    isDark ? const Color(0xFF2A2A2A) : Colors.white,

                selectedItemColor: Colors.green.shade600,
                unselectedItemColor:
                    isDark ? Colors.white60 : Colors.grey.shade500,

                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 12,
                ),

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
        ),
      ),
    );
  }
}
