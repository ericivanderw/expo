import 'package:flutter/material.dart';
import 'package:expo/widgets/button.dart';
import 'package:expo/user/tambah_kendaraan.dart';
import 'package:expo/user/detail_kendaraan_view.dart';
import 'package:expo/widgets/page_header.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaftarKendaraanPage extends StatefulWidget {
  final int initialFilter;
  const DaftarKendaraanPage({super.key, this.initialFilter = 0});

  @override
  State<DaftarKendaraanPage> createState() => _DaftarKendaraanPageState();
}

class _DaftarKendaraanPageState extends State<DaftarKendaraanPage> {
  late int _selectedFilter;
  List<Map<String, dynamic>> _vehicles = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    final storage = GetStorage();
    final userId = storage.read("userId");

    if (userId == null) {
      print("❌ userId tidak ditemukan di GetStorage");
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kendaraan_request')
          .where('ownerId', isEqualTo: userId)
          .get();

      print("Jumlah data ditemukan: ${snapshot.docs.length}");

      for (var doc in snapshot.docs) {
        print("DOC ID: ${doc.id} => ${doc.data()}");
      }

      final data = snapshot.docs.map((doc) {
        final d = doc.data();
        return {
          'id': doc.id,
          'licensePlate': d['plat'] ?? 'Unknown',
          'status': d['status'] ?? 'pending',
          'statusColor': _getStatusColor(d['status']),
          'ownerName': d['merk'],      // atau nama user kalau ada
          'address': d['jenis'],       // sementara isi jenis kendaraan
          'type': d['jenis'],
          'arrivalDate': (d['createdAt'] as Timestamp).toDate().toString(),
        };
      }).toList();

      setState(() {
        _vehicles = data;
        _loading = false;
      });
    } catch (e) {
      print("🔥 ERROR GET VEHICLES: $e");
    }
  }

  Color _getStatusColor(String? s) {
    switch (s) {
      case "verified":
        return Colors.green;
      case "expired":
        return Colors.red;
      default:
        return Colors.orange; // Pending / Unverified
    }
  }

  List<Map<String, dynamic>> get _filteredVehicles {
    final filterStatus = ['pending', 'verified', 'expired'][_selectedFilter];
    return _vehicles.where((v) => v['status'] == filterStatus).toList();
  }

  int get _pendingCount =>
      _vehicles.where((v) => v['status'] == 'pending').length;
  int get _verifiedCount =>
      _vehicles.where((v) => v['status'] == 'verified').length;
  int get _expiredCount =>
      _vehicles.where((v) => v['status'] == 'expired').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          PageHeader(
            title: "Kendaraanku",
            showBackButton: false,
            rightIcon: Image.asset(
              'assets/icon-list.png',
              width: 60,
              height: 60,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Center(
                          child: ConstrainedBox(
                            constraints:
                            const BoxConstraints(maxWidth: 600),
                            child: Column(
                              children: [
                                _buildStatsSection(),
                                const SizedBox(height: 20),
                                _buildFilterSection(),
                                const SizedBox(height: 10),
                                _buildVehicleList(),
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(bottom: 20, left: 20, right: 20, child: _buildAddButton()),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return _responsiveBox(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8E8E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Kendaraan",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Period 2024",
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard("pending", _pendingCount.toString(),
                      Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                      "Verified", _verifiedCount.toString(), Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: color),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(fontSize: 14, color: Colors.black54)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return _responsiveBox(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Expanded(child: _buildFilterChip("pending", 0, _pendingCount)),
            const SizedBox(width: 6),
            Expanded(child: _buildFilterChip("verified", 1, _verifiedCount)),
            const SizedBox(width: 6),
            Expanded(child: _buildFilterChip("expired", 2, _expiredCount)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index, int count) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedFilter = index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF7C68BE) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromARGB(255, 241, 144, 87)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _filteredVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = _filteredVehicles[index];
        return _buildVehicleCard(vehicle);
      },
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailKendaraanViewPage(
              namaPemilik: vehicle['ownerName'] ?? 'Unknown',
              alamat: vehicle['address'] ?? 'Unknown',
              jenisKendaraan: vehicle['type'] ?? 'Unknown',
              status: vehicle['status'] ?? 'Unknown',
              kedatangan: vehicle['arrivalDate'],
              platKendaraan: vehicle['licensePlate'] ?? 'Unknown',
              fotoKendaraan: null,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.directions_car, color: Colors.grey),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle['licensePlate'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          size: 8, color: vehicle['statusColor']),
                      const SizedBox(width: 6),
                      Text(
                        vehicle['status'],
                        style: TextStyle(
                          fontSize: 14,
                          color: vehicle['statusColor'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: CustomButton(
          text: "Tambah Kendaraan",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahKendaraanPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _responsiveBox({required Widget child}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double maxContentWidth = 600;
        double defaultPadding = 20;
        double horizontalPadding = (screenWidth - maxContentWidth) / 2;

        if (horizontalPadding < defaultPadding) {
          horizontalPadding = defaultPadding;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: child,
        );
      },
    );
  }
}
