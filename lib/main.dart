import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'screens/login.dart';
import 'providers/chat_provider.dart';
import 'themes/theme_provider.dart';
import 'screens/citizen_root_screen.dart';
import 'screens/volunteer_root_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  runApp(
  MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => ChatProvider()), // NEW AI
  ],
  child: const MyApp(),
),

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,

          //  LIGHT THEME
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF4F9F4),

            colorScheme: ColorScheme.light(
              primary: Colors.green.shade700,
              secondary: Colors.green.shade400,
            ),

            appBarTheme: AppBarTheme(
              backgroundColor: Colors.green.shade700,
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.15),
              centerTitle: true,
              titleTextStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
              ),
            ),

            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              elevation: 20,
              selectedItemColor: Colors.green.shade700,
              unselectedItemColor: Colors.grey.shade500,
              selectedIconTheme:
                  IconThemeData(size: 30, color: Colors.green.shade700),
              type: BottomNavigationBarType.fixed,
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade700,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          //  DARK THEME
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF1B1C1E),

            colorScheme: ColorScheme.dark(
              primary: Colors.green.shade300,
              secondary: Colors.green.shade200,
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF252628),
              elevation: 3,
              shadowColor: Colors.black54,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
              ),
            ),

            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: const Color(0xFF252628),
              elevation: 18,
              selectedItemColor: Colors.green.shade300,
              unselectedItemColor: Colors.white60,
              selectedIconTheme: IconThemeData(
                color: Colors.green.shade300,
                size: 30,
              ),
              type: BottomNavigationBarType.fixed,
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green.shade600,
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          home: const LoginScreen(),

          onGenerateRoute: (settings) {
            if (settings.name == '/citizen') {
              return MaterialPageRoute(
                builder: (_) => const CitizenRootScreen(),
              );
            }

            if (settings.name == '/volunteer') {
              return MaterialPageRoute(
                builder: (_) => const VolunteerRootScreen(),
              );
            }

            return null;
          },
        );
      },
    );
  }
}













