import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailKendaraanViewPage extends StatefulWidget {
  final String vehicleId;

  const DetailKendaraanViewPage({super.key, required this.vehicleId});

  @override
  State<DetailKendaraanViewPage> createState() =>
      _DetailKendaraanViewPageState();
}

class _DetailKendaraanViewPageState extends State<DetailKendaraanViewPage> {
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final vehicleDoc = await FirebaseFirestore.instance
        .collection('kendaraan_request')
        .doc(widget.vehicleId)
        .get();

    if (!vehicleDoc.exists) {
      throw Exception('Vehicle not found');
    }

    final vehicleData = vehicleDoc.data() as Map<String, dynamic>;
    final ownerId = vehicleData['ownerId'];

    Map<String, dynamic>? userData;
    if (ownerId != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(ownerId)
          .get();
      if (userDoc.exists) {
        userData = userDoc.data();
      }
    }

    return {'vehicle': vehicleData, 'user': userData};
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
          'Detail Kendaraan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data tidak ditemukan'));
          }

          final vehicleData = snapshot.data!['vehicle'];
          final userData = snapshot.data!['user'];

          // Get owner name: try 'nama' then 'username' from user data, fallback to 'merk' or '-'
          String namaPemilik = '-';

          if (userData != null) {
            namaPemilik = userData['nama'] ?? userData['username'] ?? '-';
          } else {
            // Fallback if user not found but we have vehicle data (though unlikely if ownerId exists)
            namaPemilik = vehicleData['merk'] ?? '-';
          }

          final jenisKendaraan = vehicleData['jenis'] ?? '-';
          final status = vehicleData['status'] ?? 'Pending';
          final platKendaraan = vehicleData['plat'] ?? '-';
          final fotoUrl =
              vehicleData['foto_kendaraan'] ?? vehicleData['stnkUrl'];
          final kedatangan = vehicleData['createdAt'] != null
              ? (vehicleData['createdAt'] as Timestamp).toDate().toString()
              : null;

          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailCard('Nama Pemilik', namaPemilik),
                    const SizedBox(height: 12),
                    _buildDetailCard('Jenis Kendaraan', jenisKendaraan),
                    const SizedBox(height: 12),
                    _buildDetailCard('Status', status),
                    const SizedBox(height: 12),
                    if (status == 'Tamu' && kedatangan != null) ...[
                      _buildDetailCard('Kedatangan', kedatangan),
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
                    if (fotoUrl != null && fotoUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          fotoUrl,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildPlaceholderImage();
                          },
                        ),
                      )
                    else
                      _buildPlaceholderImage(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
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
