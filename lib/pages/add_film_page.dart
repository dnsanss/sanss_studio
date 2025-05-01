import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddFilmPage extends StatefulWidget {
  const AddFilmPage({super.key});

  @override
  State<AddFilmPage> createState() => _AddFilmPageState();
}

class _AddFilmPageState extends State<AddFilmPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final imageUrlController = TextEditingController();
  final durationController = TextEditingController();

  void submitFilm() async {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    final image = imageUrlController.text.trim();
    final duration = durationController.text.trim();

    if (title.isEmpty || desc.isEmpty || image.isEmpty || duration.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field harus diisi.')));
      return;
    }

    try {
      await Supabase.instance.client.from('films').insert({
        'title': title,
        'description': desc,
        'image_url': image,
        'duration': duration,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Film berhasil ditambahkan!')),
      );
      Navigator.pop(context); // kembali ke halaman sebelumnya
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan film: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Film')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul Film'),
            ),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            TextFormField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Link Gambar/Poster',
              ),
            ),
            TextFormField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Durasi (menit)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: submitFilm,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Film'),
            ),
          ],
        ),
      ),
    );
  }
}
