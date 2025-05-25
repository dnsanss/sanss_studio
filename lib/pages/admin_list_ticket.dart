import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class AdminListTicketPage extends StatefulWidget {
  const AdminListTicketPage({super.key});

  @override
  State<AdminListTicketPage> createState() => _AdminListTicketPageState();
}

class _AdminListTicketPageState extends State<AdminListTicketPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<dynamic> ticketList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      final response = await supabase
          .from('booking')
          .select('*, user_id: users(*), schedules: schedules_id(*), price')
          .order('created_at', ascending: false);

      if (!mounted) return;
      setState(() {
        ticketList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching tickets: $e')));
    }
  }

  void refreshTickets() {
    setState(() {
      isLoading = true;
      ticketList.clear();
    });
    fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ticket Bookings')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ticketList.isEmpty
              ? const Center(child: Text('Tidak ada tiket yang ditemukan.'))
              : ListView.builder(
                itemCount: ticketList.length,
                itemBuilder: (context, index) {
                  final movie = ticketList[index];
                  final schedules = movie['schedules'] ?? {};
                  final formattedPrice = NumberFormat.currency(
                    locale: 'id',
                    symbol: 'Rp ',
                    decimalDigits: 0,
                  ).format(movie['price']);
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Poster
                          schedules['image_url'] != null
                              ? Image.network(
                                schedules['image_url'],
                                width: 60,
                                height: 90,
                                fit: BoxFit.cover,
                              )
                              : const Icon(Icons.image_not_supported, size: 60),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        schedules['tittle'] ??
                                            'Tidak ada judul',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Atas Nama: ${movie['user_id']?['nama'] ?? '-'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Jadwal Tayang: ${schedules['day'] ?? '-'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Jam Tayang: ${schedules['time'] ?? '-'}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Harga: $formattedPrice',
                                  style: const TextStyle(fontSize: 14),
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
    );
  }
}
