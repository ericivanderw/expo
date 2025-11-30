import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:expo/admin/detail_penghuni_admin.dart';

class DaftarPenghuniAdminPage extends StatefulWidget {
  const DaftarPenghuniAdminPage({super.key});

  @override
  State<DaftarPenghuniAdminPage> createState() =>
      _DaftarPenghuniAdminPageState();
}

class _DaftarPenghuniAdminPageState extends State<DaftarPenghuniAdminPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFFF5F5F5)),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .where('role', isEqualTo: 'user')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data!.docs;

                      // Filter based on search query
                      final filteredData = data.where((doc) {
                        final userData = doc.data() as Map<String, dynamic>;
                        final name =
                            userData['username']?.toString().toLowerCase() ??
                            '';
                        return name.contains(_searchQuery.toLowerCase());
                      }).toList();

                      if (filteredData.isEmpty) {
                        return const Center(child: Text('No residents found'));
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          return _buildResidentCard(filteredData[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/admin/tambah_penghuni');
        },
        backgroundColor: const Color(0xFF7C68BE),
        child: const Icon(Icons.add, color: Colors.white),
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
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            40, // Top padding for status bar
            horizontalPadding,
            30,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF7C68BE), // Solid purple color
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Daftar Penghuni",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Data Penghuni Perumahan.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                  // Placeholder for the bird/moon illustration
                  Image.asset(
                    'assets/icon-clock.png',
                    width: 80, // Increased size
                    height: 80,
                    color: Colors.white.withOpacity(0.8), // Slight transparency
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0), // Light grey background
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "Search",
                          border: InputBorder.none,
                          suffixIcon: Icon(Icons.search, color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.print_outlined, // Outline icon
                    color: Colors.black54,
                    size: 30,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResidentCard(DocumentSnapshot doc) {
    final resident = doc.data() as Map<String, dynamic>;
    resident['id'] = doc.id; // Add ID to map
    final String name = resident['username'] ?? 'No Name';
    final String address = resident['alamat'] ?? 'No Address';
    final String userId = doc.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8), // Light grey card background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Nama Penghuni",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Alamat Penghuni",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.black12),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // FutureBuilder to count vehicles
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('plat_terdaftar')
                    .where('ownerId', isEqualTo: userId)
                    .get(),
                builder: (context, snapshot) {
                  int vehicleCount = 0;
                  if (snapshot.hasData) {
                    vehicleCount = snapshot.data!.docs.length;
                  }
                  return Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Jumlah Kendaraan : $vehicleCount",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  );
                },
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailPenghuniAdminPage(resident: resident),
                    ),
                  );
                },
                child: const Text(
                  "See Details",
                  style: TextStyle(
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
}
