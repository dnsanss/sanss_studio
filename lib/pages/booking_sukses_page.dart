import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sanss_studio/pages/home_pages.dart';

class BookingSuksesPage extends StatefulWidget {
  final Map<String, dynamic> booking;

  const BookingSuksesPage({super.key, required this.booking});

  @override
  State<BookingSuksesPage> createState() => _BookingSuksesPageState();
}

class _BookingSuksesPageState extends State<BookingSuksesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSuccessDialog(context);
    });
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[50],
                  radius: 36,
                  child: Icon(Icons.check_circle, color: Colors.blue, size: 60),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Terima kasih telah memesan tiket di aplikasi kami. Silakan datang tepat waktu dan nikmati filmnya!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final schedules = widget.booking['schedules']; // relasi ke tabel movies
    final users = widget.booking['user_id']; // relasi ke tabel users
    final formattedPrice = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(booking['price']);

    return Scaffold(
      appBar: AppBar(title: const Text('Booking Telah Berhasil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  schedules['image_url'] != null
                      ? Image.network(
                        schedules['image_url'],
                        width: 160,
                        height: 220,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 160,
                        height: 220,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 48),
                      ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Nama Pemesan :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${users?['nama'] ?? '-'}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "ID Pemesanan :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SelectableText(
                  "${widget.booking['id']}",
                  style: const TextStyle(fontSize: 13.5),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Judul Film :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${schedules['tittle']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Jadwal :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${schedules['day']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Jam Tayang :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${schedules['time']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Jumlah Tiket :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.booking['jumlah_tiket']}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Harga :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  formattedPrice,
                  style: const TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                backgroundColor: Colors.blueAccent,
              ),
              child: const Text(
                "Kembali ke Halaman Utama",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
