import 'package:flutter/material.dart';
import 'package:expo/widgets/appbarback.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DetailKendaraanPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailKendaraanPage({super.key, required this.data});

  @override
  @override
  Widget build(BuildContext context) {
    final String statusText = data['status'] ?? '-';
    final bool isExit = statusText.toLowerCase() == 'keluar';
    final Color statusColor = isExit ? Colors.red : Colors.green;
    print("Detail Data: $data"); // Debug print

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const AppBarBack(title: "Details"),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: statusColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Details Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: _fetchVehicleDetails(data['plat'] ?? ''),
                    builder: (context, snapshot) {
                      String ownerName = "Loading...";
                      String jenis = "Loading...";
                      String date = "Loading...";

                      if (snapshot.hasData) {
                        ownerName = snapshot.data!['ownerName'] ?? '-';
                        jenis = snapshot.data!['jenis'] ?? '-';
                        date = snapshot.data!['date'] ?? '-';
                      } else if (snapshot.hasError) {
                        ownerName = "-";
                        jenis = "-";
                        date = "-";
                      } else if (snapshot.connectionState ==
                              ConnectionState.done &&
                          !snapshot.hasData) {
                        ownerName = "-";
                        jenis = "-";
                        date = "-";
                      }

                      return Column(
                        children: [
                          _buildDetailField("Nama Pemilik", ownerName),
                          const SizedBox(height: 16),
                          _buildDetailField(
                            "Plat Kendaraan",
                            data['plat'] ?? '-',
                          ),
                          const SizedBox(height: 16),
                          _buildDetailField("Jenis Kendaraan", jenis),
                          const SizedBox(height: 16),
                          _buildDetailField("Tanggal & Waktu", date),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchVehicleDetails(String plat) async {
    if (plat.isEmpty) return {};
    try {
      Map<String, dynamic>? vehicleData;

      // 1. Cari kendaraan di kendaraan_request berdasarkan plat
      var vehicleQuery = await FirebaseFirestore.instance
          .collection('kendaraan_request')
          .where('plat', isEqualTo: plat)
          .limit(1)
          .get();

      if (vehicleQuery.docs.isNotEmpty) {
        vehicleData = vehicleQuery.docs.first.data();
      } else {
        // 2. Jika tidak ada, cari di plat_terdaftar
        var platQuery = await FirebaseFirestore.instance
            .collection('plat_terdaftar')
            .where('plat', isEqualTo: plat)
            .limit(1)
            .get();

        if (platQuery.docs.isNotEmpty) {
          vehicleData = platQuery.docs.first.data();
        }
      }

      if (vehicleData == null) return {};

      final ownerId = vehicleData['ownerId'];
      final jenis = vehicleData['jenis'] ?? '-';

      // Format Date
      String dateStr = '-';
      if (vehicleData['createdAt'] != null) {
        if (vehicleData['createdAt'] is Timestamp) {
          DateTime dt = (vehicleData['createdAt'] as Timestamp).toDate();
          dateStr = "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute}";
        } else {
          dateStr = vehicleData['createdAt'].toString();
        }
      }

      // 3. Cari nama user di users berdasarkan ownerId
      String ownerName = '-';
      if (ownerId != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(ownerId)
            .get();

        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          ownerName = userData['nama'] ?? userData['username'] ?? '-';
        }
      }

      return {'ownerName': ownerName, 'jenis': jenis, 'date': dateStr};
    } catch (e) {
      print("Error fetching vehicle details: $e");
      return {};
    }
  }
}
