import 'package:flutter/material.dart';
import 'package:expo/widgets/page_header.dart';

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
    _selectedStatus = widget.vehicle['status'] ?? 'Menunggu';
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    if (_selectedStatus == 'Approved') {
      statusColor = Colors.green;
      statusText = 'Verified';
    } else if (_selectedStatus == 'Rejected') {
      statusColor = Colors.red;
      statusText = 'Rejected';
    } else {
      statusColor = const Color(0xFF7C68BE); // Purple for Review
      statusText = 'Review';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          const PageHeader(title: 'Detail Kendaraan'),
          // Scrollable Content
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
                      // Status Section
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
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Submitted at ${widget.vehicle['submittedDate'] ?? 'Unknown'}',
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

                      // Detail Boxes
                      _buildDetailBox('Nama Pemilik', widget.vehicle['owner']),
                      const SizedBox(height: 12),
                      _buildDetailBox('Alamat', 'Blok G No.1'), // Mock data
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        'Jenis Kendaraan',
                        widget.vehicle['type'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        'Plat Kendaraan',
                        widget.vehicle['plate'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailBox(
                        'Keterangan',
                        widget.vehicle['keterangan'] ?? 'Data Valid',
                      ),
                      const SizedBox(height: 24),

                      // Foto Kendaraan
                      const Text(
                        'Foto Kendaraan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          widget.vehicle['foto'] ?? 'assets/car.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Buttons
          if (_selectedStatus != 'Approved' && _selectedStatus != 'Rejected')
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedStatus = 'Approved';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kendaraan disetujui'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF65A278,
                              ), // Muted Green
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Approve',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedStatus = 'Rejected';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Kendaraan ditolak'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFFA85656,
                              ), // Muted Red
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Rejected',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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

  Widget _buildDetailBox(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEAEAEA), // Lighter grey
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
