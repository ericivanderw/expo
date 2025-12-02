import 'package:flutter/material.dart';
import 'package:expo/widgets/page_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailKendaraanApprovalAdminPage extends StatefulWidget {
  final Map<String, dynamic> vehicle;

  const DetailKendaraanApprovalAdminPage({super.key, required this.vehicle});

  @override
  State<DetailKendaraanApprovalAdminPage> createState() =>
      _DetailKendaraanApprovalAdminPageState();
}

class _DetailKendaraanApprovalAdminPageState
    extends State<DetailKendaraanApprovalAdminPage> {
  String _selectedStatus = 'Menunggu';

  @override
  void initState() {
    super.initState();
    _selectedStatus = (widget.vehicle['status'] ?? 'pending')
        .toString()
        .toLowerCase();
  }

  Future<void> updateStatus(String newStatus) async {
    final firestore = FirebaseFirestore.instance;
    final v = widget.vehicle;

    final docId = v['id'];

    try {
      // Update status request
      await firestore.collection('kendaraan_request').doc(docId).update({
        'status': newStatus,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Jika approved → masukkan ke plat_terdaftar
      if (newStatus == 'approved') {
        await firestore.collection('plat_terdaftar').add({
          'plat': v['plate'] ?? '',
          'merk': v['merk'] ?? '',
          'jenis': v['type'] ?? '',
          'ownerId': v['ownerId'] ?? '-',
          'fotoUrl': v['fotoUrl'] ?? '',
          'kategori': v['kategori'] ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'approvedAt': FieldValue.serverTimestamp(),
        });
      }

      Navigator.pop(context, true);
    } catch (e) {
      print("🔥 ERROR UPDATE STATUS: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    if (_selectedStatus == 'approved') {
      statusColor = Colors.green;
      statusText = 'Verified';
    } else if (_selectedStatus == 'rejected') {
      statusColor = Colors.red;
      statusText = 'Rejected';
    } else {
      statusColor = const Color(0xFF7C68BE);
      statusText = 'Review';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          const PageHeader(title: 'Detail Kendaraan', showBackButton: false),

          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 120, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
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
                      // STATUS BOX
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Status',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Submitted at ${widget.vehicle['createdAt'] ?? '-'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              statusText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // DETAIL BOXES
                      _buildDetailBox(
                        'Nama Pemilik',
                        widget.vehicle['owner'] ?? '-',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        'Jenis Kendaraan',
                        widget.vehicle['type'] ?? '-',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        'Plat Kendaraan',
                        widget.vehicle['plate'] ?? '-',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        'Keterangan',
                        widget.vehicle['kategori'] ?? '-',
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // BUTTON APPROVE/REJECT
          if (_selectedStatus != 'approved' && _selectedStatus != 'rejected')
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => updateStatus("Approved"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Approve',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => updateStatus("Rejected"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF44336),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Reject',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // CUSTOM BACK BUTTON (Positioned on top)
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
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
          ),
        ],
      ),
    );
  }

  // SAFE DETAIL BOX
  Widget _buildDetailBox(String label, dynamic value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(value?.toString() ?? '-', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
