import 'package:flutter/material.dart';

class RootScaffold extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final Widget body;

  const RootScaffold({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: body,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            if (theme.brightness == Brightness.light)
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          selectedItemColor: Colors.green.shade600,
          unselectedItemColor:
              theme.brightness == Brightness.dark
                  ? Colors.white60
                  : Colors.grey,
          backgroundColor:
              theme.brightness == Brightness.dark
                  ? const Color(0xFF222222)
                  : Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Dashboard",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy),
              label: "AI",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            ),
          ],
        ),
      ),
    );
  }
}
