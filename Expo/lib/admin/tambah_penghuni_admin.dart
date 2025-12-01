import 'package:cloud_firestore/cloud_firestore.dart';
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

  bool _isLoading = false;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final String id = _idController.text.trim();
        final String username = _usernameController.text.trim();

        // Check if ID or Username already exists
        final idCheck = await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .get();
        final usernameCheck = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: username)
            .get();

        if (idCheck.exists) {
          throw 'ID Penghuni sudah digunakan';
        }

        if (usernameCheck.docs.isNotEmpty) {
          throw 'Username sudah digunakan';
        }

        // Create user document
        await FirebaseFirestore.instance.collection('users').doc(id).set({
          'nama': _namaController.text.trim(),
          'username': username,
          'password': _passwordController.text.trim(),
          'alamat': _alamatController.text.trim(),
          'no_hp': _phoneController.text.trim(),
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Penghuni berhasil ditambahkan')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          const PageHeader(title: "Tambah Penghuni", showBackButton: false),
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
                            text: _isLoading ? "Loading..." : "Submit",
                            onPressed: _isLoading ? () {} : _submit,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF7C68BE),
                        size: 20,
                      ),
                    ),
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
