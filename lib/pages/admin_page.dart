import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_film_page.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<Map<String, dynamic>> filmList = [];

  Future<String?> fetchAdminName() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null) {
      await Supabase.instance.client
          .from('films')
          .select()
          .order('judul', ascending: true);

      setState(() {
        filmList = filmList;
      });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Daftar Film:', style: TextStyle(fontSize: 16)),
                  ],
                ),
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
                                  subtitle: Text(film['genre'] ?? ''),
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
