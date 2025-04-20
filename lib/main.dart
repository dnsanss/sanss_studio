import 'package:flutter/material.dart';
import 'package:sanss_studio/auth/login_page.dart';
//import 'package:sanss_studio/auth/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://blhkvyrsrfiolybjziaz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJsaGt2eXJzcmZpb2x5Ymp6aWF6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwNjE5OTgsImV4cCI6MjA2MDYzNzk5OH0.aIz-Hd4wChUKIkdV5WrJ0qg5A5QMjA6_ohL_rHaOg6M',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Film',
      theme: ThemeData(useMaterial3: true),
      home: const LoginPage(), // halaman pertama saat app dibuka
    );
  }
}
