import 'package:flutter/material.dart';
import 'package:expo/widgets/page_header.dart';
import 'package:expo/widgets/button.dart';

class TambahPenghuniAdminPage extends StatefulWidget {
  const TambahPenghuniAdminPage({super.key});

  @override
  State<TambahPenghuniAdminPage> createState() =>
      _TambahPenghuniAdminPageState();
}

class _TambahPenghuniAdminPageState extends State<TambahPenghuniAdminPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _idController = TextEditingController(
    text: "088",
  );
  final TextEditingController _namaController = TextEditingController(
    text: "Andi",
  );
  final TextEditingController _usernameController = TextEditingController(
    text: "Andi",
  );
  final TextEditingController _passwordController = TextEditingController(
    text: "Andi123",
  );
  final TextEditingController _alamatController = TextEditingController(
    text: "Blok G No.1",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "0888999998888",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          const PageHeader(title: "Tambah Penghuni"),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel("ID Penghuni"),
                                _buildTextField(_idController),
                                const SizedBox(height: 16),
                                _buildLabel("Nama Penghuni"),
                                _buildTextField(_namaController),
                                const SizedBox(height: 16),
                                _buildLabel("Username"),
                                _buildTextField(_usernameController),
                                const SizedBox(height: 16),
                                _buildLabel("Password"),
                                _buildTextField(
                                  _passwordController,
                                  isPassword: true,
                                ),
                                const SizedBox(height: 16),
                                _buildLabel("Alamat"),
                                _buildTextField(_alamatController),
                                const SizedBox(height: 16),
                                _buildLabel("Nomor Handphone"),
                                _buildTextField(
                                  _phoneController,
                                  isNumber: true,
                                ),
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
                        child: SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: "Submit",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // Handle submit
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    bool isPassword = false,
    bool isNumber = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field ini tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}
