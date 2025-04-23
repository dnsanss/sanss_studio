import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  Future<String?> fetchAdminName() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      await Supabase.instance.client
          .from('films')
          .select()
          .order('judul', ascending: true);
    }
    return null;
  }

  void logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: fetchAdminName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Menu Admin:', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Tambah film atau fitur lainnya di sini
                  },
                  child: const Text('Kelola Daftar Film'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Fitur selanjutnya
                  },
                  child: const Text('Lihat Data Pemesanan'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
