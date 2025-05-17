import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditFilmPage extends StatefulWidget {
  final Map<String, dynamic> film;

  const EditFilmPage({super.key, required this.film});

  @override
  State<EditFilmPage> createState() => _EditFilmPageState();
}

class _EditFilmPageState extends State<EditFilmPage> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController durationController;
  late TextEditingController dayController;
  late TextEditingController timeController;
  late TextEditingController priceController;

  XFile? _image;
  Uint8List? _imageBytes;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.film['tittle']);
    descriptionController = TextEditingController(
      text: widget.film['description'],
    );
    durationController = TextEditingController(
      text: widget.film['duration']?.toString() ?? '',
    );
    dayController = TextEditingController(text: widget.film['day']);
    timeController = TextEditingController(
      text: widget.film['time']?.toString() ?? '',
    );
    priceController = TextEditingController(
      text: widget.film['price']?.toString() ?? '',
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = pickedFile;
      _imageBytes = await pickedFile.readAsBytes();
      setState(() {});
    }
  }

  Future<void> updateFilm() async {
    try {
      String? imageUrl = widget.film['image_url'];

      if (_imageBytes != null) {
        final filePath = 'filmposters/${_image!.name}';
        await Supabase.instance.client.storage
            .from('filmposters')
            .uploadBinary(
              filePath,
              _imageBytes!,
              fileOptions: const FileOptions(upsert: true),
            );
        imageUrl = Supabase.instance.client.storage
            .from('filmposters')
            .getPublicUrl(filePath);
      }

      await Supabase.instance.client
          .from('movies')
          .update({
            'tittle': titleController.text,
            'description': descriptionController.text,
            'duration': int.tryParse(durationController.text),
            'image_url': imageUrl,
            'day': dayController.text,
            'time': timeController.text,
            'price': int.tryParse(priceController.text),
          })
          .eq('id', widget.film['id']);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Film berhasil diperbarui!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui film: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Film')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
              maxLines: 3,
            ),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                color: Colors.grey[300],
                height: 100,
                width: 100,
                child:
                    _imageBytes != null
                        ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                        : widget.film['image_url'] != null
                        ? Image.network(
                          widget.film['image_url'],
                          fit: BoxFit.cover,
                        )
                        : const Icon(Icons.add_a_photo),
              ),
            ),
            TextField(
              controller: durationController,
              decoration: const InputDecoration(labelText: 'Durasi (menit)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: dayController,
              decoration: const InputDecoration(labelText: 'Jadwal Hari'),
            ),
            TextFormField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Jam Tayang'),
            ),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: updateFilm,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
