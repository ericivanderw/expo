import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:expo/admin/detail_kendaraan_approval_admin.dart';
import 'package:expo/widgets/page_header.dart';
import 'package:intl/intl.dart';
import 'package:expo/widgets/button.dart';
import 'package:expo/user/tambah_kendaraan.dart';

class DaftarKendaraanAdminPage extends StatefulWidget {
  final String? initialStatus;
  const DaftarKendaraanAdminPage({super.key, this.initialStatus});

  @override
  State<DaftarKendaraanAdminPage> createState() =>
      _DaftarKendaraanAdminPageState();
}

class _DaftarKendaraanAdminPageState extends State<DaftarKendaraanAdminPage> {
  String _selectedStatus = 'Pending'; // default Menunggu (Review)
  bool _loading = true;

  List<Map<String, dynamic>> _allVehicles = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialStatus != null) {
      _selectedStatus = widget.initialStatus!;
    }
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('kendaraan_request')
          .orderBy('createdAt', descending: true)
          .get();

      // Fetch all unique ownerIds first to minimize reads
      final ownerIds = snapshot.docs
          .map((doc) => doc.data()['ownerId'] as String?)
          .where((id) => id != null && id.isNotEmpty)
          .toSet();

      final Map<String, String> ownerNames = {};
      if (ownerIds.isNotEmpty) {
        // Firestore 'in' query supports up to 10 items.
        // For scalability, it's better to fetch individually or in batches.
        // For now, we'll fetch individually as it's simpler and safer for small datasets.
        // Optimization: In a real app, use a batched fetch or cache.
        for (var id in ownerIds) {
          if (id == null) continue;
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(id)
              .get();
          if (userDoc.exists) {
            final data = userDoc.data();
            ownerNames[id] = data?['nama'] ?? data?['username'] ?? 'Unknown';
          }
        }
      }

      final vehicles = snapshot.docs.map((doc) {
        final d = doc.data();

        String rawStatus = d['status']?.toString().toLowerCase() ?? 'pending';
        String normalizedStatus = 'Pending';

        if (rawStatus == 'approved' || rawStatus == 'verified') {
          normalizedStatus = 'Approved';
        } else if (rawStatus == 'rejected') {
          normalizedStatus = 'Rejected';
        } else {
          normalizedStatus = 'Pending';
        }

        final ownerId = d['ownerId'] ?? '';
        final ownerName = ownerNames[ownerId] ?? 'Unknown User';

        return {
          'id': doc.id,
          'plate': d['plat'] ?? '',
          'owner': ownerName, // Now correctly populated from users collection
          'vehicleName':
              d['merk'] ?? '', // This might still be empty if not saved
          'color': "N/A",
          'type': d['jenis'] ?? '',
          'status': normalizedStatus,
          'date': d['createdAt'] != null
              ? (d['createdAt'] as Timestamp).toDate()
              : null,
          'kategori': d['kategori'] ?? '', // Map kategori from Firestore
          'keterangan':
              d['kategori'] ??
              '', // Also map to keterangan for backward compatibility if needed
          'foto': 'assets/car.png',
          'ownerId': ownerId,
          'submittedDate': d['createdAt'] != null
              ? (d['createdAt'] as Timestamp).toDate().toString()
              : '',
          'createdAt': d['createdAt'] != null
              ? DateFormat(
                  'd MMM yyyy, HH:mm',
                ).format((d['createdAt'] as Timestamp).toDate())
              : '-',
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

  Future<void> approveRequest(String docId, Map<String, dynamic> data) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // 1️⃣ Update status di kendaraan_request
      await firestore.collection('kendaraan_request').doc(docId).update({
        'status': 'Approved',
        'approvedAt': FieldValue.serverTimestamp(),
      });

      // 2️⃣ Masukkan data ke collection plat_terdaftar (pakai field yg BENER)
      await firestore.collection('plat_terdaftar').add({
        'plat': data['plate'], // dari _loadVehicles
        'merk': data['owner'], // merk = owner
        'jenis': data['type'], // jenis kendaraan
        'ownerId': data['ownerId'], // ownerId asli
        'createdAt': data['date'], // tanggal submit
        'approvedAt': FieldValue.serverTimestamp(),
        'keterangan': data['kategori'],
      });

      print("⭐ APPROVED & DIPINDAHKAN ke plat_terdaftar");

      // optional: refresh UI
      await _loadVehicles();
      setState(() {});
    } catch (e) {
      print("🔥 ERROR APPROVE: $e");
    }
  }

  List<Map<String, dynamic>> get _filteredVehicles {
    return _allVehicles.where((v) {
      return v['status'] == _selectedStatus;
    }).toList();
  }

  int get _totalCount => _allVehicles.length;
  int get _reviewCount =>
      _allVehicles.where((v) => v['status'] == 'Pending').length;
  int get _verifiedCount =>
      _allVehicles.where((v) => v['status'] == 'Approved').length;
  int get _rejectedCount =>
      _allVehicles.where((v) => v['status'] == 'Rejected').length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          const PageHeader(title: 'Daftar\nKendaraan', rightIcon: null),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          Expanded(
                            child: _loading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView(
                                    padding: const EdgeInsets.fromLTRB(
                                      16,
                                      16,
                                      16,
                                      100,
                                    ),
                                    children: [
                                      _buildStatsSection(),
                                      const SizedBox(height: 20),
                                      _buildStatusTabs(),
                                      const SizedBox(height: 16),
                                      ..._filteredVehicles.map(
                                        (vehicle) => _buildVehicleCard(vehicle),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            ).then((_) => _loadVehicles());
          },
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
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
                child: _buildStatCard(
                  "Total",
                  _totalCount.toString(),
                  const Color(0xFF7C68BE),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  "Review",
                  _reviewCount.toString(),
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  "Verified",
                  _verifiedCount.toString(),
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 10, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTabItem("Review", "Pending", _reviewCount, Colors.orange),
          _buildTabItem("Approved", "Approved", _verifiedCount, Colors.green),
          _buildTabItem("Rejected", "Rejected", _rejectedCount, Colors.red),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    String label,
    String statusValue,
    int count,
    Color badgeColor,
  ) {
    final isSelected = _selectedStatus == statusValue;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => _selectedStatus = statusValue);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7C68BE) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    Color statusColor;
    String statusText;
    switch (vehicle['status']) {
      case "approved":
        statusColor = Colors.green;
        statusText = "Verified";
        break;
      case "rejected":
        statusColor = Colors.red;
        statusText = "Rejected";
        break;
      default:
        statusColor = Colors.orange;
        statusText = "Review";
    }

    String formattedDate = "";
    if (vehicle['date'] != null && vehicle['date'] is DateTime) {
      formattedDate = DateFormat('d MMM yyyy').format(vehicle['date']);
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
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
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
                    Text(
                      "See Details",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 14),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.circle, size: 12, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  statusText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Nama Pemilik",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vehicle['owner'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Jenis Kendaraan",
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          vehicle['type'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Submitted at $formattedDate",
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "By",
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    const SizedBox(width: 6),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey.shade300,
                      child: const Icon(
                        Icons.person,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      vehicle['owner'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
