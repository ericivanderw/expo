import 'dart:io';
import 'package:flutter/material.dart';

class DetailKendaraanViewPage extends StatelessWidget {
  final String namaPemilik;
  final String alamat;
  final String jenisKendaraan;
  final String status;
  final String? kedatangan; // Only for Tamu status
  final String platKendaraan;
  final File? fotoKendaraan;

  const DetailKendaraanViewPage({
    super.key,
    required this.namaPemilik,
    required this.alamat,
    required this.jenisKendaraan,
    required this.status,
    this.kedatangan,
    required this.platKendaraan,
    this.fotoKendaraan,
  });

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
          'Detail Kendaraan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailCard('Nama Pemilik', namaPemilik),
                const SizedBox(height: 12),
                _buildDetailCard('Alamat', alamat),
                const SizedBox(height: 12),
                _buildDetailCard('Jenis Kendaraan', jenisKendaraan),
                const SizedBox(height: 12),
                _buildDetailCard('Status', status),
                const SizedBox(height: 12),
                if (status == 'Tamu' && kedatangan != null) ...[
                  _buildDetailCard('Kedatangan', kedatangan!),
                  const SizedBox(height: 12),
                ],
                _buildDetailCard('Plat Kendaraan', platKendaraan),
                const SizedBox(height: 20),
                const Text(
                  'Foto Kendaraan',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                if (fotoKendaraan != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      fotoKendaraan!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.directions_car,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
