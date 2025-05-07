import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_film_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> filmList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFilms();
  }

  Future<void> fetchFilms() async {
    try {
      final response = await Supabase.instance.client
          .from('movies')
          .select('tittle, description, image_url, duration')
          .order('tittle', ascending: true);

      if (!mounted) return;
      setState(() {
        filmList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat data: $e')));
    }
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
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : filmList.isEmpty
              ? const Center(child: Text('Belum ada data film.'))
              : ListView.builder(
                itemCount: filmList.length,
                itemBuilder: (context, index) {
                  final film = filmList[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading:
                          film['image_url'] != null
                              ? Image.network(
                                film['image_url'],
                                width: 60,
                                height: 90,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.image_not_supported),
                      title: Text(film['tittle']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(film['description'] ?? ''),
                          const SizedBox(height: 4),
                          Text('Durasi: ${film['duration']} menit'),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFilmPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
