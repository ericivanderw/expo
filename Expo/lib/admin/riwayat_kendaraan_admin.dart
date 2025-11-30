import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expo/user/detail_kendaraan.dart';

class RiwayatKendaraanAdminPage extends StatefulWidget {
  const RiwayatKendaraanAdminPage({super.key});

  @override
  State<RiwayatKendaraanAdminPage> createState() => _RiwayatKendaraanAdminPageState();
}

class _RiwayatKendaraanAdminPageState extends State<RiwayatKendaraanAdminPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = '';
  String _jenisFilter = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🔥 Stream Firestore mengikuti struktur database kamu
  Stream<List<Map<String, dynamic>>> getRiwayatStream() {
    return FirebaseFirestore.instance
        .collection('smartgate_logs')
        .orderBy('waktu_masuk', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return {
          "id": doc.id,
          "plate": data['plat'] ?? '',
          "type": data['jenis'] ?? '-', // Sesuai jika kamu punya field 'jenis'
          "status": data['status'] ?? '',
          "isEntry": data['status'] == 'masuk',
          "date": data['waktu_masuk'] ?? '-',
          "waktu_keluar": data['waktu_keluar'],
        };
      }).toList();
    });
  }

  // 🔍 Filtering
  List<Map<String, dynamic>> filterData(List<Map<String, dynamic>> data) {
    return data.where((item) {
      final s = _searchQuery.toLowerCase();

      final matchesSearch = s.isEmpty ||
          item['plate'].toLowerCase().contains(s) ||
          item['type'].toLowerCase().contains(s);

      final matchesStatus =
          _statusFilter.isEmpty || item['status'] == _statusFilter;

      final matchesJenis =
          _jenisFilter.isEmpty || item['type'] == _jenisFilter;

      return matchesSearch && matchesStatus && matchesJenis;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildFilters(),
          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getRiwayatStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _emptyState();
                }

                final filtered = filterData(snapshot.data!);

                if (filtered.isEmpty) return _emptyState();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return _buildHistoryItem(filtered[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🟥 Jika data kosong
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada data ditemukan',
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  // 🔵 Header UI
  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double maxContentWidth = 600;
        double defaultPadding = 16;
        double horizontalPadding = (screenWidth - maxContentWidth) / 2;
        if (horizontalPadding < defaultPadding) {
          horizontalPadding = defaultPadding;
        }

        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8C6CCF), Color(0xFF8E9BCB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                20,
                horizontalPadding,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            "Riwayat Kendaraan",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Data Kendaraan Keluar-Masuk.",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        'assets/icon-clock.png',
                        width: 70,
                        height: 70,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // 🔍 Search bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                      decoration: InputDecoration(
                        hintText: "Search plat/type",
                        border: InputBorder.none,
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(Icons.clear,
                              color: Colors.black54),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                              _searchController.clear();
                            });
                          },
                        )
                            : const Icon(Icons.search, color: Colors.black54),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🟣 Filter chips
  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            label: "Status",
            value: _statusFilter,
            items: ['masuk', 'keluar'],
            onChanged: (value) {
              setState(() => _statusFilter = value);
            },
          ),
          const SizedBox(width: 10),
          _buildFilterChip(
            label: "Jenis Kendaraan",
            value: _jenisFilter,
            items: ['Motor', 'Mobil'],
            onChanged: (value) {
              setState(() => _jenisFilter = value);
            },
          ),
        ],
      ),
    );
  }

  // Chip builder
  Widget _buildFilterChip({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: value.isNotEmpty ? const Color(0xFF7C68BE) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: value.isNotEmpty
                ? const Color(0xFF7C68BE)
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (value.isNotEmpty)
              const Icon(Icons.filter_alt, size: 14, color: Colors.white),
            if (value.isNotEmpty) const SizedBox(width: 4),
            Text(
              value.isEmpty ? label : value,
              style: TextStyle(
                fontSize: 12,
                color: value.isNotEmpty ? Colors.white : Colors.black87,
                fontWeight:
                value.isNotEmpty ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: value.isNotEmpty ? Colors.white : Colors.black54,
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        PopupMenuItem<String>(value: '', child: Text('Semua $label')),
        ...items.map(
              (item) => PopupMenuItem<String>(value: item, child: Text(item)),
        ),
      ],
    );
  }

  // 🟢 Card item
  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final bool isEntry = item['isEntry'];
    final Color statusColor = isEntry ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plate + type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${item['plate']} • ${item['type']}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Icon(isEntry ? Icons.login : Icons.logout,
                  color: Colors.black87),
            ],
          ),

          const SizedBox(height: 8),

          // Status row
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                item['status'],
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Date + detail
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['date'],
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailKendaraanPage(data: item),
                    ),
                  );
                },
                child: const Text(
                  "See Details",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
