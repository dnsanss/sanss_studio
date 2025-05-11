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
    fetchMovies(); // Aktifkan kembali
  }

  Future<void> fetchMovies() async {
    try {
      final response = await Supabase.instance.client.from('movies').select();
      if (!mounted) return;
      setState(() {
        movies = response;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil data film: $e')));
    }
  }

  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  int _currentIndex = 0;
  List<Widget> body = const [
    Icon(Icons.home),
    Icon(Icons.local_movies),
    Icon(Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sanss Studio',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
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
                      title: Text(movie['tittle']),
                      subtitle: Text(
                        movie['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_movies),
            label: 'Ticket Status',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
