import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanss_studio/auth/login_page.dart';
import 'package:sanss_studio/pages/home_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/admin_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://blhkvyrsrfiolybjziaz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJsaGt2eXJzcmZpb2x5Ymp6aWF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwNjE5OTgsImV4cCI6MjA2MDYzNzk5OH0.aIz-Hd4wChUKIkdV5WrJ0qg5A5QMjA6_ohL_rHaOg6M',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking Film',
      theme: FlexThemeData.light(
        scheme: FlexScheme.shadBlue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.shadBlue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(),
      ),
      themeMode: ThemeMode.light,
      home: const LoginPage(), // halaman pertama saat app dibuka
      routes: {
        '/login': (_) => const LoginPage(),
        '/admin': (_) => const AdminPage(),
        '/user': (_) => const HomePage(),
      },
      // home: HomePage(),
    );
  }
}
