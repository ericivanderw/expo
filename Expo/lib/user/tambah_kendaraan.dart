import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:expo/widgets/button.dart';

class TambahKendaraanPage extends StatefulWidget {
  const TambahKendaraanPage({super.key});

  @override
  _TambahKendaraanPageState createState() => _TambahKendaraanPageState();
}

class _TambahKendaraanPageState extends State<TambahKendaraanPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _platController = TextEditingController();
  final TextEditingController _merkController =
      TextEditingController(); // Mapped to Nama Pemilik
  final TextEditingController _alamatController = TextEditingController();

  String? _selectedJenis;
  String? _selectedStatus;
  DateTime? _selectedDate;
  bool _loading = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final storage = GetStorage();
      final userId = storage.read("userId");

      if (userId != null) {
        final doc = await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .get();

        if (doc.exists) {
          final data = doc.data();
          setState(() {
            _merkController.text = data?['nama'] ?? data?['username'] ?? '';
            _alamatController.text = data?['alamat'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedJenis == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih jenis kendaraan")));
      return;
    }

    if (_selectedStatus == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih status")));
      return;
    }

    if (_selectedStatus == 'Tamu' && _selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Pilih tanggal kedatangan")));
      return;
    }

    // setState(() => _loading = true); // Handled by CustomButton

    try {
      final storage = GetStorage();
      final ownerId = storage.read("userId");

      if (ownerId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User tidak ditemukan (belum login)")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection("kendaraan_request").add({
        "plat": _platController.text.trim(),
        "jenis": _selectedJenis, // Dropdown value
        "kategori": _selectedStatus, // Nama Pemilik
        "alamat": _alamatController.text.trim(),
        "ownerId": ownerId,
        "status": "Pending",
        "kedatangan": _selectedDate,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Berhasil mengirim permintaan!")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    } finally {
      // setState(() => _loading = false); // Handled by CustomButton
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tambah Kendaraan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Nama Pemilik"),
                    _buildTextField(
                      controller: _merkController,
                      hint: "Andi",
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Alamat"),
                    _buildTextField(
                      controller: _alamatController,
                      hint: "Blok G No.1",
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Jenis Kendaraan"),
                    _buildDropdown(
                      value: _selectedJenis,
                      hint: "Pilih Jenis Kendaraan",
                      items: ["Motor", "Mobil"],
                      onChanged: (val) => setState(() => _selectedJenis = val),
                    ),
                    const SizedBox(height: 16),

                    _buildLabel("Status"),
                    _buildDropdown(
                      value: _selectedStatus,
                      hint: "Pilih kategori (Penghuni/Tamu)",
                      items: ["Penghuni", "Tamu"],
                      onChanged: (val) => setState(() {
                        _selectedStatus = val;
                        if (val == 'Penghuni') _selectedDate = null;
                      }),
                    ),
                    const SizedBox(height: 16),

                    if (_selectedStatus == 'Tamu') ...[
                      _buildLabel(
                        "Kedatangan (Maksimal sehari 1*24 jam, Request H-1)",
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F0F0),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedDate == null
                                    ? "Select Date"
                                    : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                                style: TextStyle(
                                  color: _selectedDate == null
                                      ? Colors.grey.shade600
                                      : Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.grey.shade600,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    _buildLabel("Plat Kendaraan"),
                    _buildTextField(
                      controller: _platController,
                      hint: "BP3333ED",
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: CustomButton(text: "Submit", onPressed: _submit),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey.shade200 : const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade600)),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
          items: items.map((String item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
