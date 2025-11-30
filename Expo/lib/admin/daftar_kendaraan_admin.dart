import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:expo/widgets/admin_bottom_navbar.dart';
import 'package:expo/admin/detail_kendaraan_approval_admin.dart';
import 'package:expo/widgets/page_header.dart';

class DaftarKendaraanAdminPage extends StatefulWidget {
  const DaftarKendaraanAdminPage({super.key});

  @override
  State<DaftarKendaraanAdminPage> createState() =>
      _DaftarKendaraanAdminPageState();
}

class _DaftarKendaraanAdminPageState extends State<DaftarKendaraanAdminPage> {
  String _selectedStatus = 'pending'; // default Menunggu (Review)
  bool _loading = true;

  List<Map<String, dynamic>> _allVehicles = [];

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kendaraan_request')
          .orderBy('createdAt', descending: true)
          .get();

      final vehicles = snapshot.docs.map((doc) {
        final d = doc.data();

        return {
          'id': doc.id,
          'plate': d['plat'] ?? '',
          'owner': d['merk'] ?? '',
          'vehicleName': d['merk'] ?? '',
          'color': "N/A",
          'type': d['jenis'] ?? '',
          'status': d['status'] ?? 'pending',
          'date': d['createdAt'] != null
              ? (d['createdAt'] as Timestamp).toDate().toString()
              : '',
          'keterangan': '',
          'foto': 'assets/car.png',
          'submitter': d['ownerId'] ?? '',
          'submittedDate': d['createdAt'] != null
              ? (d['createdAt'] as Timestamp).toDate().toString()
              : '',
        };
      }).toList();

      setState(() {
        _allVehicles = vehicles;
        _loading = false;
      });

      print("🔥 Data Loaded: ${vehicles.length}");
    } catch (e) {
      print("ERROR LOAD VEHICLES: $e");
    }
  }

  List<Map<String, dynamic>> get _filteredVehicles {
    return _allVehicles.where((v) {
      return v['status'] == _selectedStatus;
    }).toList();
  }

  Future<void> approveRequest(String docId, Map<String, dynamic> data) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // 1️⃣ Update status di kendaraan_request
      await firestore.collection('kendaraan_request').doc(docId).update({
        'status': 'approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });

      // 2️⃣ Masukkan data ke collection plat_terdaftar (pakai field yg BENER)
      await firestore.collection('plat_terdaftar').add({
        'plat': data['plate'],        // dari _loadVehicles
        'merk': data['owner'],        // merk = owner
        'jenis': data['type'],        // jenis kendaraan
        'ownerId': data['submitter'], // ownerId asli
        'createdAt': data['date'],    // tanggal submit
        'approvedAt': FieldValue.serverTimestamp(),
        'foto': data['foto'],         // placeholder
        'keterangan': data['keterangan'],
      });

      print("⭐ APPROVED & DIPINDAHKAN ke plat_terdaftar");

      // optional: refresh UI
      await _loadVehicles();
      setState(() {});

    } catch (e) {
      print("🔥 ERROR APPROVE: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: AdminBottomNavBar(currentIndex: 0, onTap: (i) {}),
      body: Stack(
        children: [
          const PageHeader(
            title: 'Daftar\nKendaraan',
            rightIcon: null,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 100),
                _buildStatusTabs(),
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredVehicles.length,
                    itemBuilder: (context, index) {
                      return _buildVehicleCard(_filteredVehicles[index]);
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            _buildTabItem("Review", "pending"),
            const SizedBox(width: 6),
            _buildTabItem("Approved", "approved"),
            const SizedBox(width: 6),
            _buildTabItem("Rejected", "rejected"),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, String statusValue) {
    final isSelected = _selectedStatus == statusValue;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedStatus = statusValue);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7C68BE) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
              child: Text(
                label,
                style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    Color statusColor;
    switch (vehicle['status']) {
      case "approved":
        statusColor = Colors.green;
        break;
      case "rejected":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailKendaraanApprovalAdminPage(vehicle: vehicle),
          ),
        ).then((_) => _loadVehicles()); // refresh setelah approve/reject
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plate + see details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vehicle['plate'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Row(
                  children: [
                    Text("See Details"),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 14),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  vehicle['status'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nama Pemilik"),
                          Text(vehicle['owner'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      )),
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Jenis Kendaraan"),
                          Text(vehicle['type'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
