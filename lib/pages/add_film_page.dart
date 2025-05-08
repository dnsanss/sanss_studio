import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddFilmPage extends StatefulWidget {
  const AddFilmPage({super.key});

  @override
  State<AddFilmPage> createState() => _AddFilmPageState();
}

class _AddFilmPageState extends State<AddFilmPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  Uint8List? _imageBytes;

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  // Fungsi untuk menyimpan data film
  Future<void> submitFilm() async {
    final title = titleController.text.trim();
    final desc = descriptionController.text.trim();
    final duration = durationController.text.trim();

    if (title.isEmpty ||
        desc.isEmpty ||
        duration.isEmpty ||
        _imageBytes == null ||
        _imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field dan gambar harus diisi.')),
      );
      return;
    }

    try {
      final filePath =
          'filmposters/${DateTime.now().millisecondsSinceEpoch}_${_imageFile!.name}';

      // Upload gambar ke Supabase Storage
      await Supabase.instance.client.storage
          .from('filmposters')
          .uploadBinary(filePath, _imageBytes!);

      // Ambil URL publik dari gambar
      final imageUrl = Supabase.instance.client.storage
          .from('filmposters')
          .getPublicUrl(filePath);

      // Simpan data film ke tabel
      await Supabase.instance.client.from('movies').insert({
        'tittle': title,
        'description': desc,
        'image_url': imageUrl,
        'duration': duration,
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Film berhasil ditambahkan!')),
      );

      Navigator.pop(context);
    } catch (e) {
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
        child: SingleChildScrollView(
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
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child:
                      _imageBytes != null
                          ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                          : const Center(
                            child: Icon(Icons.add_a_photo, size: 40),
                          ),
                ),
              ),
              const SizedBox(height: 16),
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
      ),
    );
  }
}
