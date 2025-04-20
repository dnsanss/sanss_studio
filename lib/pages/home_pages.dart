import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> movies = [];

  String? userName;

  @override
  void initState() {
    super.initState();
    fetchUserName();
    //fetchMovies();
  }

  Future<void> fetchUserName() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;
    final data =
        await Supabase.instance.client
            .from('users')
            .select('nama')
            .eq('id', userId)
            .single();

    setState(() {
      userName = data['nama'];
    });
  }

  void logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName == null ? 'Loading...' : 'Halo, $userName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),

      body:
          movies.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: Image.network(
                        movie['image_url'],
                        width: 50,
                        errorBuilder:
                            (context, _, __) => const Icon(Icons.image),
                      ),
                      title: Text(movie['title']),
                      subtitle: Text(
                        movie['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        // TODO: pindah ke detail film
                      },
                    ),
                  );
                },
              ),
    );
  }
}
