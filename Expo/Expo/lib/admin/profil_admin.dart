import 'package:flutter/material.dart';
import 'package:expo/admin/daftar_kendaraan_admin.dart';
import 'package:expo/user/notifikasi.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expo/auth/signin_merged.dart';

class ProfilAdminPage extends StatefulWidget {
  const ProfilAdminPage({super.key});

  @override
  State<ProfilAdminPage> createState() => _ProfilAdminPageState();
}

class _ProfilAdminPageState extends State<ProfilAdminPage> {
  String _userName = "";
  int _unverifiedCount = 0;
  int _verifiedCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final storage = GetStorage();
    final userId = storage.read("userId");

    if (userId == null) return;

    try {
      // 1. Fetch Admin Profile
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      String name = "Admin";
      if (userDoc.exists) {
        final data = userDoc.data();
        name = data?['nama'] ?? data?['username'] ?? "Admin";
      }

      // 2. Fetch All Requests to count
      final requestSnap = await FirebaseFirestore.instance
          .collection('kendaraan_request')
          .get();

      int unverified = 0;
      int verified = 0;

      for (var doc in requestSnap.docs) {
        final data = doc.data();
        final rawStatus = data['status']?.toString().toLowerCase() ?? 'pending';

        if (rawStatus == 'approved' || rawStatus == 'verified') {
          verified++;
        } else if (rawStatus != 'rejected') {
          // Assuming anything not approved/verified/rejected is pending/unverified
          unverified++;
        }
      }

      if (mounted) {
        setState(() {
          _userName = name;
          _unverifiedCount = unverified;
          _verifiedCount = verified;
        });
      }
    } catch (e) {
      print("Error fetching admin data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7C68BE), // Purple background
      body: RefreshIndicator(
        onRefresh: _fetchUserData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              // 1. Content Body (White part)
              Column(
                children: [
                  const SizedBox(height: 180), // Space for header
                  Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 180,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 80), // Space for avatar
                        _buildProfileInfo(),
                        const SizedBox(height: 20),
                        _buildStatsSection(context),
                        const SizedBox(height: 20),
                        _buildContactSection(),
                        const SizedBox(height: 20),
                        _buildAccountSection(),
                        const SizedBox(height: 20),
                        _buildSettingsSection(context),
                        const SizedBox(height: 30), // Bottom padding
                      ],
                    ),
                  ),
                ],
              ),

              // 2. Header Content (Text & Notif)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Tentang Saya",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NotifikasiPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 3. Avatar (Positioned absolute)
              Positioned(
                top: 110,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB0A4D8),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 4),
                      image: const DecorationImage(
                        image: AssetImage('assets/avatar_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        Text(
          _userName.isEmpty ? "Loading..." : _userName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Admin",
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF7C68BE),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Kendaraan Penghuni",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DaftarKendaraanAdminPage(
                                    initialStatus: 'Pending',
                                  ),
                            ),
                          ).then((_) => _fetchUserData());
                        },
                        child: _buildStatCard(
                          "Unverified",
                          _unverifiedCount.toString(),
                          Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DaftarKendaraanAdminPage(
                                    initialStatus: 'Approved',
                                  ),
                            ),
                          ).then((_) => _fetchUserData());
                        },
                        child: _buildStatCard(
                          "Verified",
                          _verifiedCount.toString(),
                          Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildContactSection() {
    return _buildSectionContainer(
      children: [
        _buildMenuItem(
          icon: Icons.headset_mic,
          title: "Hubungi Kami",
          onTap: () {},
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.privacy_tip,
          title: "Kebijakan Privasi",
          onTap: () {},
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.description,
          title: "Syarat & Ketentuan",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSectionContainer(
      children: [
        _buildMenuItem(
          icon: Icons.person_outline,
          title: "Ubah Profil",
          onTap: () {},
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.lock_outline,
          title: "Ubah Password",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return _buildSectionContainer(
      children: [
        _buildMenuItem(
          icon: Icons.logout,
          title: "Keluar",
          textColor: Colors.red,
          iconColor: Colors.red,
          onTap: () {
            // Clear storage
            final storage = GetStorage();
            storage.remove("userId");
            storage.remove("role");
            storage.remove("remember_password"); // Prevent auto-login
            // Navigate to login
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const SignInMergedPage()),
              (route) => false,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSectionContainer({required List<Widget> children}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
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
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
    Color iconColor = const Color(0xFF7C68BE),
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0));
  }
}
