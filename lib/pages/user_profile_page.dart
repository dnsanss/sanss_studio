import 'package:flutter/material.dart';
import 'package:sanss_studio/auth/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? userName;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      final response =
          await Supabase.instance.client
              .from('users')
              .select()
              .eq('id', user.id)
              .single();

      setState(() {
        userName = response['nama'];
        userEmail = user.email;
      });
    }
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();

    // Navigasi ke halaman login dan hapus semua riwayat
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akun Saya')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.person, size: 100, color: Colors.blueAccent),
            const SizedBox(height: 20),
            Text(
              userName ?? 'Memuat nama...',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              userEmail ?? 'Memuat email...',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Divider(thickness: 1),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Keluar'),
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
