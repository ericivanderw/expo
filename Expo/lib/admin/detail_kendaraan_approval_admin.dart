import 'package:flutter/material.dart';
import 'package:expo/widgets/page_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expo/services/localization_service.dart';
import 'package:intl/intl.dart';

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
      // 1. Fetch ORIGINAL document to ensure we copy ALL fields exactly
      final docSnap = await firestore
          .collection('kendaraan_request')
          .doc(docId)
          .get();

      if (!docSnap.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: Data tidak ditemukan (sudah dihapus?)"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final originalData = docSnap.data() as Map<String, dynamic>;

      // 2. Prepare data to save (Copy original fields)
      final dataToSave = Map<String, dynamic>.from(originalData);

      // 3. Add Status Fields
      if (newStatus == 'Approved') {
        dataToSave['approvedAt'] = FieldValue.serverTimestamp();
        // Ensure 'status' is updated if needed, or keep original?
        // Usually approved docs don't need 'status' field if collection implies it,
        // but let's set it to Verified/Approved just in case.
        dataToSave['status'] = 'Verified';

        // Add to plat_terdaftar
        await firestore.collection('plat_terdaftar').add(dataToSave);

        // Delete from kendaraan_request
        await firestore.collection('kendaraan_request').doc(docId).delete();

        // Send Notification
        await firestore.collection('notifications').add({
          'userId': originalData['ownerId'] ?? '-',
          'title': tr('kendaraan_disetujui'),
          'message':
              '${tr('kendaraan_dengan_plat')} ${originalData['plat'] ?? '-'} ${tr('telah_disetujui_admin')}',
          'type': 'vehicle_status',
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else if (newStatus == 'Rejected') {
        dataToSave['rejectedAt'] = FieldValue.serverTimestamp();
        dataToSave['status'] = 'Rejected';

        // Add to plat_ditolak
        await firestore.collection('plat_ditolak').add(dataToSave);

        // Delete from kendaraan_request
        await firestore.collection('kendaraan_request').doc(docId).delete();

        // Send Notification
        await firestore.collection('notifications').add({
          'userId': originalData['ownerId'] ?? '-',
          'title': tr('kendaraan_ditolak'),
          'message':
              '${tr('kendaraan_dengan_plat')} ${originalData['plat'] ?? '-'} ${tr('telah_ditolak_admin')}',
          'type': 'vehicle_status',
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
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

    // Normalize status for display logic
    String currentStatus = _selectedStatus.toLowerCase();

    if (currentStatus == 'approved' || currentStatus == 'verified') {
      statusColor = Colors.green;
      statusText = tr('approved');
    } else if (currentStatus == 'rejected') {
      statusColor = Colors.red;
      statusText = tr('rejected');
    } else {
      statusColor = const Color(0xFF7C68BE);
      statusText = tr('pending');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          PageHeader(
            title: tr('detail_kendaraan'),
            showBackButton: false,
            titleTopPadding: 16.0,
          ),

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
                              Text(
                                tr('status'),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${tr('submitted_at')} ${widget.vehicle['createdAt'] ?? '-'}',
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
                        tr('nama_pemilik'),
                        widget.vehicle['owner'] ?? '-',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        tr('jenis_kendaraan'),
                        tr(
                          (widget.vehicle['type'] ?? '-')
                              .toString()
                              .toLowerCase(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        tr('plat_kendaraan'),
                        widget.vehicle['plate'] ?? '-',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        tr('keterangan'),
                        tr(
                          (widget.vehicle['kategori'] ?? '-')
                              .toString()
                              .toLowerCase(),
                        ),
                      ),
                      if ((widget.vehicle['kategori'] ?? '')
                              .toString()
                              .toLowerCase() ==
                          'tamu') ...[
                        const SizedBox(height: 12),
                        Builder(
                          builder: (context) {
                            dynamic rawDate = widget.vehicle['kedatangan'];
                            String dateStr = '-';
                            if (rawDate != null) {
                              if (rawDate is Timestamp) {
                                dateStr = DateFormat(
                                  'dd MMM yyyy',
                                  LocalizationService()
                                      .localeNotifier
                                      .value
                                      .languageCode,
                                ).format(rawDate.toDate());
                              } else {
                                dateStr = rawDate.toString();
                              }
                            }
                            return _buildDetailBox(
                              tr('tanggal_kedatangan'),
                              dateStr,
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Back Button (Positioned on top to be clickable)
          // Back Button (Positioned on top to be clickable)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 38,
                      ), // Matches PageHeader: 28 (padding) + 10 (button top)
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
                              color: Color(0xFFFEFEFE),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Color(0xFF7A5AF8),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
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
                            child: Text(
                              tr('approve'),
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
                            child: Text(
                              tr('reject'),
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
