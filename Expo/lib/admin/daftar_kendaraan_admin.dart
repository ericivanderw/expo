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
  String _selectedStatus = 'Menunggu'; // Default to Review (Menunggu)

  final List<Map<String, dynamic>> _allVehicles = [
    {
      'plate': 'BP1234CD',
      'owner': 'Budi',
      'vehicleName': 'Toyota Avanza',
      'color': 'Hitam',
      'type': 'Mobil',
      'status': 'Approved',
      'date': 'Approved at 10 Oct 2024',
      'keterangan': 'Mobil keluarga',
      'foto': 'assets/car.png',
      'submitter': 'Budi',
      'submittedDate': '10 Oct 2024',
    },
    {
      'plate': 'BP5678EF',
      'owner': 'Nana',
      'vehicleName': 'Honda Beat',
      'color': 'Merah',
      'type': 'Motor',
      'status': 'Menunggu',
      'date': 'Menunggu',
      'keterangan': 'Motor pribadi',
      'foto': 'assets/car.png',
      'submitter': 'Nana',
      'submittedDate': '15 Oct 2024',
    },
    {
      'plate': 'BP3333ED',
      'owner': 'Andi',
      'vehicleName': 'Suzuki Ertiga',
      'color': 'Putih',
      'type': 'Mobil',
      'status': 'Menunggu',
      'date': 'Menunggu',
      'keterangan': 'Tidak sesuai',
      'foto': 'assets/car.png',
      'submitter': 'Andi',
      'submittedDate': '15 Oct 2024',
    },
    {
      'plate': 'BP9101GH',
      'owner': 'Andi',
      'vehicleName': 'Suzuki Ertiga',
      'color': 'Putih',
      'type': 'Mobil',
      'status': 'Rejected',
      'date': '12 Oct 2024',
      'keterangan': 'Tidak sesuai',
      'foto': 'assets/car.png',
      'submitter': 'Andi',
      'submittedDate': '12 Oct 2024',
    },
  ];

  List<Map<String, dynamic>> get _filteredVehicles {
    return _allVehicles.where((vehicle) {
      return vehicle['status'] == _selectedStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: AdminBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/admin/pengumuman');
              break;
            case 2:
              Navigator.pushNamed(context, '/admin/riwayat_kendaraan');
              break;
            case 3:
              break;
          }
        },
      ),
      body: Stack(
        children: [
          PageHeader(
            title: 'Daftar\nKendaraan',
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
                                // Stats Cards
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE0E0E0),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Daftar Kendaraan',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Period 2024',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            _buildStatItem(
                                              'Total',
                                              '13',
                                              const Color(0xFF7C68BE),
                                              Icons.confirmation_number,
                                            ),
                                            const SizedBox(width: 8),
                                            _buildStatItem(
                                              'Review',
                                              '3',
                                              const Color(
                                                0xFFC69C6D,
                                              ), // Gold/Brown
                                              Icons.circle,
                                            ),
                                            const SizedBox(width: 8),
                                            _buildStatItem(
                                              'Verified',
                                              '10',
                                              Colors.green,
                                              Icons.circle,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                _buildStatusTabs(),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: _filteredVehicles.length,
                                  itemBuilder: (context, index) {
                                    return _buildVehicleCard(
                                      _filteredVehicles[index],
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
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
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE), // Slightly lighter grey
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              count,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
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
            _buildTabItem('Review', '3', 'Menunggu'),
            const SizedBox(width: 6),
            _buildTabItem('Approved', '10', 'Approved'),
            const SizedBox(width: 6),
            _buildTabItem('Rejected', '0', 'Rejected'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, String count, String statusValue) {
    final bool isSelected = _selectedStatus == statusValue;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedStatus = statusValue;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
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
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color.fromARGB(255, 241, 144, 87)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 12,
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
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    Color statusColor;
    if (vehicle['status'] == 'Approved') {
      statusColor = Colors.green;
    } else if (vehicle['status'] == 'Rejected') {
      statusColor = Colors.red;
    } else {
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
        );
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Plate and See Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  vehicle['plate'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Row(
                  children: [
                    Text(
                      'See Details',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 14, color: Colors.black87),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Status
            Row(
              children: [
                Icon(Icons.circle, size: 12, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  vehicle['status'] == 'Menunggu'
                      ? 'Review'
                      : (vehicle['status'] == 'Approved'
                            ? 'Verified'
                            : vehicle['status']),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Details Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), // Light grey background
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
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
            const SizedBox(height: 16),
            // Footer: Date and Submitter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      vehicle['status'] == 'Approved'
                          ? Icons.check_circle
                          : (vehicle['status'] == 'Rejected'
                                ? Icons.cancel
                                : Icons.check_circle),
                      size: 16,
                      color: vehicle['status'] == 'Approved'
                          ? Colors.green
                          : (vehicle['status'] == 'Rejected'
                                ? Colors.red
                                : Colors.grey),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vehicle['status'] == 'Approved'
                          ? '${vehicle['date'] ?? 'Unknown'}'
                          : (vehicle['status'] == 'Rejected'
                                ? 'Rejected at ${vehicle['date'] ?? 'Unknown'}'
                                : 'Submitted at ${vehicle['submittedDate'] ?? 'Unknown'}'),
                      style: TextStyle(
                        fontSize: 12,
                        color: vehicle['status'] == 'Approved'
                            ? Colors.green
                            : (vehicle['status'] == 'Rejected'
                                  ? Colors.red
                                  : Colors.grey), // Grey for Review/Menunggu
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'By',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: const AssetImage('assets/profil.png'),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      vehicle['submitter'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
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
