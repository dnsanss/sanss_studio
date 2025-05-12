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
              : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Now Showing',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 52, 222),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 260,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final movie = movies[index];
                          return Container(
                            width: 170,
                            margin: EdgeInsets.only(
                              left: 16,
                              right: index == movies.length - 1 ? 16 : 0,
                            ),
                            child: Card(
                              color: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Poster
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      movie['image_url'],
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, _, __) =>
                                              const Icon(Icons.image),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Judul
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                    ),
                                    child: Text(
                                      movie['tittle'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // Jadwal
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 13,
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Colors.white70,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          movie['day'] ?? '',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
