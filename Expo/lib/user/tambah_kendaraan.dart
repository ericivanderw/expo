import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:expo/widgets/button.dart';

class TambahKendaraanPage extends StatefulWidget {
  const TambahKendaraanPage({super.key});

  @override
  State<TambahKendaraanPage> createState() => _TambahKendaraanPageState();
}

class _TambahKendaraanPageState extends State<TambahKendaraanPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaPemilikController = TextEditingController();
  final _alamatController = TextEditingController();
  final _platKendaraanController = TextEditingController();

  String? _selectedJenisKendaraan;
  String? _selectedStatus;
  DateTime? _selectedDate;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _namaPemilikController.dispose();
    _alamatController.dispose();
    _platKendaraanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Kendaraan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
                  children: [
                    _buildTextField(
                      label: 'Nama Pemilik',
                      controller: _namaPemilikController,
                      hint: 'Andi',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      label: 'Alamat',
                      controller: _alamatController,
                      hint: 'Blok G No.1',
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Jenis Kendaraan',
                      value: _selectedJenisKendaraan,
                      hint: 'Select Jenis',
                      items: ['Motor', 'Mobil'],
                      onChanged: (v) =>
                          setState(() => _selectedJenisKendaraan = v),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Status',
                      value: _selectedStatus,
                      hint: 'Select Status (Penghuni/Tamu)',
                      items: ['Penghuni', 'Tamu'],
                      onChanged: (v) => setState(() => _selectedStatus = v),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedStatus == 'Tamu') ...[
                      _buildDateField(),
                      const SizedBox(height: 16),
                    ],
                    _buildTextField(
                      label: 'Plat Kendaraan',
                      controller: _platKendaraanController,
                      hint: 'BP3333ED',
                    ),
                    const SizedBox(height: 16),
                    _buildPhotoUploadSection(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _buildSubmitButton(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(
              hint,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            items: items
                .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kedatangan (Maksimal sehari 1*24 jam, Request H-1)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: TextStyle(
                    color: _selectedDate == null
                        ? Colors.grey.shade400
                        : Colors.black87,
                    fontSize: 14,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Foto Kendaraan',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Upload dengan format .pdf .jpeg .png max 2MB.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            final XFile? image = await _picker.pickImage(
              source: ImageSource.gallery,
              maxWidth: 1920,
              maxHeight: 1920,
              imageQuality: 85,
            );
            if (image != null) {
              setState(() => _selectedImage = File(image.path));
            }
          },
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: _selectedImage == null
                ? const Center(
                    child: Icon(
                      Icons.upload_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: 'Submit',
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Navigator.pop(context);
        }
      },
    );
  }
}
