import 'package:flutter/material.dart';
import 'detail_kendaraan.dart';

class RiwayatKendaraanPage extends StatefulWidget {
  const RiwayatKendaraanPage({super.key});

  @override
  State<RiwayatKendaraanPage> createState() => _RiwayatKendaraanPageState();
}

class _RiwayatKendaraanPageState extends State<RiwayatKendaraanPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _statusFilter = '';
  String _jenisFilter = '';

  final List<Map<String, dynamic>> _historyData = [
    {
      "plate": "BP1234CD",
      "type": "Mobil",
      "status": "Keluar",
      "date": "28 Sept 2024, 14.30",
      "isEntry": false,
    },
    {
      "plate": "BP5678EF",
      "type": "Motor",
      "status": "Masuk",
      "date": "27 Sept 2024, 07.30",
      "isEntry": true,
    },
    {
      "plate": "BP1234CD",
      "type": "Mobil",
      "status": "Masuk",
      "date": "25 Sept 2024, 21.00",
      "isEntry": true,
    },
    {
      "plate": "BP1234CD",
      "type": "Mobil",
      "status": "Keluar",
      "date": "25 Sept 2024, 05.30",
      "isEntry": false,
    },
    {
      "plate": "BP5678EF",
      "type": "Motor",
      "status": "Masuk",
      "date": "24 Sept 2024, 08.00",
      "isEntry": true,
    },
  ];

  List<Map<String, dynamic>> get _filteredHistory {
    return _historyData.where((item) {
      final matchesSearch =
          _searchQuery.isEmpty ||
              item['plate'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              item['type'].toString().toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );

      final matchesStatus =
          _statusFilter.isEmpty || item['status'] == _statusFilter;
      final matchesJenis = _jenisFilter.isEmpty || item['type'] == _jenisFilter;

      return matchesSearch && matchesStatus && matchesJenis;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: _filteredHistory.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada data ditemukan',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  itemCount: _filteredHistory.length,
                  itemBuilder: (context, index) {
                    return _buildHistoryItem(_filteredHistory[index]);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search plat/type",
                        border: InputBorder.none,
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black54,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            });
                          },
                        )
                            : const Icon(Icons.search, color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
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

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            label: "Status",
            value: _statusFilter,
            items: ['Masuk', 'Keluar'],
            onChanged: (value) {
              setState(() {
                _statusFilter = value;
              });
            },
          ),
          const SizedBox(width: 10),
          _buildFilterChip(
            label: "Jenis Kendaraan",
            value: _jenisFilter,
            items: ['Motor', 'Mobil'],
            onChanged: (value) {
              setState(() {
                _jenisFilter = value;
              });
            },
          ),
        ],
      ),
    );
  }

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
            if (value.isNotEmpty) ...[
              const Icon(Icons.filter_alt, size: 14, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              value.isEmpty ? label : value,
              style: TextStyle(
                fontSize: 12,
                color: value.isNotEmpty ? Colors.white : Colors.black87,
                fontWeight: value.isNotEmpty
                    ? FontWeight.w600
                    : FontWeight.normal,
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

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final bool isEntry = item['isEntry'];
    final Color statusColor = isEntry ? Colors.green : Colors.red;
    final String statusText = item['status'];

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
              Icon(isEntry ? Icons.login : Icons.logout, color: Colors.black87),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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

