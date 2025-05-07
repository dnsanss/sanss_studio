import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_film_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> filmList = [];

  // Fungsi untuk mengambil data film dari Supabase
  Future<void> fetchFilms() async {
    try {
      final response = await Supabase.instance.client
          .from('movies')
          .select()
          .order('judul', ascending: true);

      if (!mounted) return;

      setState(() {
        filmList = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data film: $e')));
    }
  }

  void logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  void initState() {
    super.initState();
    fetchFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daftar Film:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Expanded(
              child:
                  filmList.isEmpty
                      ? const Center(child: Text('Belum ada film.'))
                      : ListView.builder(
                        itemCount: filmList.length,
                        itemBuilder: (context, index) {
                          final film = filmList[index];
                          return Card(
                            child: ListTile(
                              leading:
                                  film['image_url'] != null
                                      ? Image.network(
                                        film['image_url'],
                                        width: 50,
                                        fit: BoxFit.cover,
                                      )
                                      : const Icon(Icons.movie),
                              title: Text(film['title']),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  // fitur hapus nanti
                                },
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFilmPage()),
          ).then((_) => fetchFilms()); // refresh daftar film setelah kembali
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
