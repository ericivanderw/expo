import 'package:flutter/material.dart';
import 'package:expo/widgets/button.dart';
import 'package:expo/user/tambah_kendaraan.dart';
import 'package:expo/user/detail_kendaraan_view.dart';
import 'package:expo/widgets/page_header.dart';

class DaftarKendaraanPage extends StatefulWidget {
  final int initialFilter;
  const DaftarKendaraanPage({super.key, this.initialFilter = 0});

  @override
  State<DaftarKendaraanPage> createState() => _DaftarKendaraanPageState();
}

class _DaftarKendaraanPageState extends State<DaftarKendaraanPage> {
  late int _selectedFilter; // 0: Unverified, 1: Verified, 2: Expired

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter;
  }

  final List<Map<String, dynamic>> _mockVehicles = [
    {
      'licensePlate': 'BP5555WD',
      'status': 'Unverified',
      'statusColor': Colors.orange,
    },
    {
      'licensePlate': 'BP1234AB',
      'status': 'Verified',
      'statusColor': Colors.green,
    },
  ];

  List<Map<String, dynamic>> get _filteredVehicles {
    final filterStatus = ['Unverified', 'Verified', 'Expired'][_selectedFilter];
    return _mockVehicles.where((v) => v['status'] == filterStatus).toList();
  }

  int get _unverifiedCount =>
      _mockVehicles.where((v) => v['status'] == 'Unverified').length;
  int get _verifiedCount =>
      _mockVehicles.where((v) => v['status'] == 'Verified').length;
  int get _expiredCount =>
      _mockVehicles.where((v) => v['status'] == 'Expired').length;

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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                        ), // Spacing for header overlap
                        Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 600),
                            child: Column(
                              children: [
                                _buildStatsSection(),
                                const SizedBox(height: 20),
                                _buildFilterSection(),
                                const SizedBox(height: 10),
                                _buildVehicleList(),
                                const SizedBox(
                                  height: 100,
                                ), // Space for bottom button
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

          // Bottom Button
          Positioned(bottom: 20, left: 20, right: 20, child: _buildAddButton()),

          // Floating Back Button (to ensure clickability over ScrollView)
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF7C68BE),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
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
                      child: _buildStatCard(
                        "Unverified",
                        _unverifiedCount.toString(),
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
          ),
        );
      },
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
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
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
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterChip("Unverified", 0, _unverifiedCount),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _buildFilterChip("Verified", 1, _verifiedCount),
                ),
                const SizedBox(width: 6),
                Expanded(child: _buildFilterChip("Expired", 2, _expiredCount)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, int index, int count) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = index;
        });
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
                overflow: TextOverflow.ellipsis,
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
                  color: isSelected
                      ? const Color.fromARGB(255, 255, 255, 255)
                      : Colors.black54,
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
              fotoKendaraan: null, // TODO: Add photo data
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
            // Vehicle Image Placeholder
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
            // Vehicle Info
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
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: vehicle['statusColor'],
                      ),
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
}
