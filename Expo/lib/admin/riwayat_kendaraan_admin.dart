import 'package:flutter/material.dart';
import 'package:expo/admin/detail_kendaraan_admin.dart';

class RiwayatKendaraanAdminPage extends StatefulWidget {
  const RiwayatKendaraanAdminPage({super.key});

  @override
  State<RiwayatKendaraanAdminPage> createState() =>
      _RiwayatKendaraanAdminPageState();
}

class _RiwayatKendaraanAdminPageState extends State<RiwayatKendaraanAdminPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedStatus = 'Semua';
  String _selectedJenis = 'Semua';

  final List<Map<String, dynamic>> _allVehicles = [
    {
      'plate': 'BP1234CD',
      'status': 'Keluar',
      'owner': 'Budi',
      'type': 'Mobil',
      'date': '28 Sept 2024, 14.30',
    },
    {
      'plate': 'BP5678EF',
      'status': 'Masuk',
      'owner': 'Nana',
      'type': 'Motor',
      'date': '30 Sept 2024, 07.30',
    },
    {
      'plate': 'BP1234CD',
      'status': 'Keluar',
      'owner': 'Andi',
      'type': 'Mobil',
      'date': '01 Oct 2024, 08.00',
    },
  ];

  List<Map<String, dynamic>> get _filteredVehicles {
    return _allVehicles.where((vehicle) {
      final matchesSearch =
          vehicle['plate'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          vehicle['owner'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      final matchesStatus =
          _selectedStatus == 'Semua' || vehicle['status'] == _selectedStatus;

      final matchesJenis =
          _selectedJenis == 'Semua' || vehicle['type'] == _selectedJenis;

      return matchesSearch && matchesStatus && matchesJenis;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildFilters(),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredVehicles.length,
                            itemBuilder: (context, index) {
                              return _buildVehicleCard(
                                _filteredVehicles[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double maxContentWidth = 600;
        double defaultPadding = 20;
        double horizontalPadding = (screenWidth - maxContentWidth) / 2;

        if (horizontalPadding < defaultPadding) {
          horizontalPadding = defaultPadding;
        }

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 20,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8C6CCF), Color(0xFF8E9BCB)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Riwayat Kendaraan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Data Kendaraan Keluar-Masuk.',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  Image.asset('assets/logo.png', width: 60, height: 60),
                ],
              ),
              const SizedBox(height: 16),
              // Search bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    const Icon(Icons.search, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              'Status',
              _selectedStatus,
              ['Semua', 'Masuk', 'Keluar'],
              (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildFilterDropdown(
              'Jenis Kendaraan',
              _selectedJenis,
              ['Semua', 'Mobil', 'Motor'],
              (value) {
                setState(() {
                  _selectedJenis = value!;
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tanggal & Waktu', style: TextStyle(fontSize: 12)),
                  Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox(),
        style: const TextStyle(fontSize: 12, color: Colors.black87),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    final isKeluar = vehicle['status'] == 'Keluar';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Plate and exit icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle['plate'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: isKeluar ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        vehicle['status'],
                        style: TextStyle(
                          fontSize: 14,
                          color: isKeluar ? Colors.red : Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(
                isKeluar ? Icons.logout : Icons.login,
                size: 28,
                color: isKeluar ? Colors.red : Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Gray box with owner and vehicle type
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Pemilik',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle['owner'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis Kendaraan',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle['type'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Bottom row: date and See Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                vehicle['date'],
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailKendaraanAdminPage(vehicle: vehicle),
                    ),
                  );
                },
                child: const Text(
                  'See Details',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
