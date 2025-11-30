import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_kendaraan.dart';
import 'package:get_storage/get_storage.dart';


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

  List<Map<String, dynamic>> _historyData = [];
  List<String> userPlates = [];
  bool _isLoading = true;

  // Storage (boleh tetap final)
  final storage = GetStorage();

  // ⛔ Tidak boleh read dalam deklarasi
  // final String currentUserID = storage.read("userId"); // ERROR

  // ✅ Ganti dengan late (diisi pada initState)
  late String currentUserID;

  @override
  void initState() {
    super.initState();

    // 🔥 Sekarang aman: object State sudah siap
    currentUserID = storage.read("userId") ?? "";
    print("USER ID = $currentUserID");   // <── CEK INI

    _loadUserPlates();
  }

  Future<void> _loadUserPlates() async {
    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('plat_terdaftar')
          .where('ownerId', isEqualTo: currentUserID)
          .get();




      userPlates =
          snapshot.docs.map((doc) => doc['plat'].toString()).toList();

      await _fetchLogs();
    } catch (e) {
      print("Error load plat: $e");
    }

    setState(() => _isLoading = false);
  }

  DateTime _parseDate(dynamic raw) {
    if (raw == null) return DateTime(2000); // fallback

    // Jika Timestamp Firestore → convert
    if (raw is Timestamp) return raw.toDate();

    // Jika String → coba parse
    if (raw is String) {
      try {
        return DateTime.parse(raw);
      } catch (e) {
        print("Gagal parse String date: $raw");
        return DateTime(2000);
      }
    }

    print("Unknown date format: $raw");
    return DateTime(2000);
  }

  Future<void> _fetchLogs() async {
    final List<Map<String, dynamic>> temp = [];

    try {
      if (userPlates.isEmpty) return;

      // LOG MASUK
      final masukSnap = await FirebaseFirestore.instance
          .collection('logs_masuk')
          .where('plat', whereIn: userPlates)
          .get();

      print("LOG MASUK: ${masukSnap.docs.length}");

      for (var doc in masukSnap.docs) {
        final data = doc.data();
        final rawDate = data['waktu_masuk'];

        temp.add({
          "plat": data['plat'] ?? '',
          "type": data['type'] ?? '',
          "status": "Masuk",
          "date": _formatDate(rawDate),
          "date_raw": _parseDate(rawDate),
        });
      }

      // LOG KELUAR
      final keluarSnap = await FirebaseFirestore.instance
          .collection('logs_keluar')
          .where('plat', whereIn: userPlates)
          .get();

      print("LOG KELUAR: ${keluarSnap.docs.length}");

      for (var doc in keluarSnap.docs) {
        final data = doc.data();
        final rawDate = data['waktu_keluar'];

        temp.add({
          "plat": data['plat'] ?? '',
          "type": data['type'] ?? '',
          "status": "keluar",
          "date": _formatDate(rawDate),
          "date_raw": _parseDate(rawDate),
        });
      }

      // SORT (aman untuk null, string, timestamp)
      temp.sort((a, b) {
        DateTime ad = a['date_raw'];
        DateTime bd = b['date_raw'];
        return bd.compareTo(ad); // newest first
      });

    } catch (e) {
      print("Error load logs: $e");
    }

    setState(() => _historyData = temp);
  }


  // ─────────────────────────────────────────────

  String _formatDate(dynamic raw) {
    DateTime dt = _parseDate(raw);

    return "${dt.day} ${_monthName(dt.month)} ${dt.year}, "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  String _monthName(int m) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "Mei", "Jun",
      "Jul", "Agt", "Sep", "Okt", "Nov", "Des"
    ];
    return months[m - 1];
  }

  // ─────────────────────────────────────────────

  List<Map<String, dynamic>> get _filteredHistory {
    return _historyData.where((item) {
      final matchesSearch =
          _searchQuery.isEmpty ||
              item['plat'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item['type'].toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus =
          _statusFilter.isEmpty || item['status'] == _statusFilter;

      final matchesJenis =
          _jenisFilter.isEmpty || item['type'] == _jenisFilter;

      return matchesSearch && matchesStatus && matchesJenis;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────

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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _filteredHistory.isEmpty
                    ? _buildEmptyState()
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

  // ───────────────────────────────────────────── UI COMPONENTS ─────────────

  Widget _buildEmptyState() {
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                              _searchController.clear();
                              _searchQuery = '';
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

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            label: "Status",
            value: _statusFilter,
            items: ['Masuk', 'keluar'],
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
          children: [
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

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    final bool isEntry = item['status'] == "Masuk";
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
                "${item['plat']} • ${item['type']}",
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
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: statusColor),
              const SizedBox(width: 4),
              Text(
                statusText,
                style:
                TextStyle(color: statusColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item['date'],
                  style: const TextStyle(
                      color: Colors.black54, fontSize: 13)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailKendaraanPage(data: item),
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
