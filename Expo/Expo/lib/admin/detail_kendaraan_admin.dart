import 'package:flutter/material.dart';
import 'package:expo/widgets/appbarback.dart';

class DetailKendaraanAdminPage extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const DetailKendaraanAdminPage({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isKeluar = vehicle['status'] == 'Keluar';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const AppBarBack(title: 'Details'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 20,
                              color: isKeluar ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              vehicle['status'],
                              style: TextStyle(
                                fontSize: 16,
                                color: isKeluar ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Detail boxes
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 6,
                      right: 16,
                      bottom: 16,
                    ),
                    child: Column(
                      children: [
                        _buildDetailBox('Nama Pemilik', vehicle['owner']),
                        const SizedBox(height: 12),
                        _buildDetailBox('Plat Kendaraan', vehicle['plate']),
                        const SizedBox(height: 12),
                        _buildDetailBox('Jenis Kendaraan', vehicle['type']),
                        const SizedBox(height: 12),
                        _buildDetailBox('Tanggal & Waktu', vehicle['date']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailBox(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
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
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
