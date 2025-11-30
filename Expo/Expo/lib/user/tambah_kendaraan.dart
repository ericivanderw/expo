import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';

class TambahKendaraanPage extends StatefulWidget {
  const TambahKendaraanPage({super.key});

  @override
  _TambahKendaraanPageState createState() => _TambahKendaraanPageState();
}

class _TambahKendaraanPageState extends State<TambahKendaraanPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _platController = TextEditingController();
  final TextEditingController _jenisController = TextEditingController();
  final TextEditingController _merkController = TextEditingController();

  File? _selectedImage;
  bool _loading = false;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile, String uid) async {
    try {
      final fileName = "stnk_${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = FirebaseStorage.instance
          .ref()
          .child("kendaraan_stnk")
          .child(fileName);

      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Ambil userId dari GetStorage (Firestore login)
      final storage = GetStorage();
      final ownerId = storage.read("userId");

      if (ownerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User tidak ditemukan (belum login)")),
        );
        return;
      }

      String? imageUrl;

      // Upload foto jika user memilih gambar
      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!, ownerId);
      }

      // Simpan data request kendaraan
      await FirebaseFirestore.instance.collection("kendaraan_request").add({
        "plat": _platController.text.trim(),
        "jenis": _jenisController.text.trim(),
        "merk": _merkController.text.trim(),
        "ownerId": ownerId,
        "stnkUrl": imageUrl ?? "",
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil mengirim permintaan!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kendaraan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _platController,
                decoration: const InputDecoration(
                  labelText: "Nomor Plat",
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Plat kendaraan wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _jenisController,
                decoration: const InputDecoration(
                  labelText: "Jenis Kendaraan (Motor/Mobil)",
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Jenis kendaraan wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _merkController,
                decoration: const InputDecoration(
                  labelText: "Merk Kendaraan",
                ),
                validator: (v) =>
                v == null || v.isEmpty ? "Merk kendaraan wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _selectedImage == null
                      ? const Center(child: Text("Upload Foto STNK (optional)"))
                      : Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Kirim Permintaan"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
