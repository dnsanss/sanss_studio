import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingPage extends StatefulWidget {
  final Map film;

  const BookingPage({super.key, required this.film});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int jumlahOrang = 1;
  late int harga;
  late int totalHarga;
  String? userName;

  @override
  void initState() {
    super.initState();
    harga = widget.film['price'] ?? 0;
    totalHarga = harga;
    fetchUser();
  }

  Future<void> fetchUser() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) return;

    final response =
        await Supabase.instance.client
            .from('users')
            .select('nama')
            .eq('id', userId)
            .maybeSingle();
    if (response != null && response['nama'] != null) {
      setState(() {
        userName = response['nama'];
      });
    } else {
      debugPrint('Nama tidak ditemukan untuk user ini');
    }
  }

  void updateTotalHarga() {
    setState(() {
      totalHarga = harga * jumlahOrang;
    });
  }

  Future<void> konfirmasiBooking() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    await Supabase.instance.client.from('booking').insert({
      'users': userId,
      'schedules': widget.film['id'],
      'jumlah_orang': jumlahOrang,
      'price': totalHarga,
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Tiket berhasil dipesan!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final film = widget.film;
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Tiket')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  film['image_url'],
                  width: 160,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nama Pemesan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(userName ?? '', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Judul Film',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(film['tittle'], style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jadwal',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('${film['day']}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Jam Tayang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('${film['time']}', style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Berapa Orang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed:
                          jumlahOrang > 1
                              ? () {
                                setState(() => jumlahOrang--);
                                updateTotalHarga();
                              }
                              : null,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text('$jumlahOrang', style: const TextStyle(fontSize: 18)),
                    IconButton(
                      onPressed: () {
                        setState(() => jumlahOrang++);
                        updateTotalHarga();
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Harga',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp $totalHarga',
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: konfirmasiBooking,
                child: const Text(
                  'Konfirmasi Pembelian Tiket',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
