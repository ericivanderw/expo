import 'package:flutter/material.dart';
import 'package:expo/user/daftar_kendaraan.dart';
import 'package:expo/user/notifikasi.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF7C68BE), // Purple background for the top part
      child: Stack(
        children: [
          // Header Content (Text & Notif)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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

          // Scrollable Body with Rounded Top
          Padding(
            padding: const EdgeInsets.only(
              top: 150,
            ), // Adjust start of white part
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
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
                    _buildSettingsSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),

          // Avatar (Positioned absolute relative to the stack)
          Positioned(
            top: 80, // 150 (padding) - 70 (half avatar)
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
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: const [
        Text(
          "Andi",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Penghuni",
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
                "Kendaraanku",
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
                                  const DaftarKendaraanPage(initialFilter: 0),
                            ),
                          );
                        },
                        child: _buildStatCard("Unverified", "1", Colors.orange),
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
                                  const DaftarKendaraanPage(initialFilter: 1),
                            ),
                          );
                        },
                        child: _buildStatCard("Verified", "2", Colors.green),
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
        color: const Color(0xFFDCDCDC), // Slightly darker grey for inner cards
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

  Widget _buildContactSection() {
    return _buildSectionContainer(
      title: "Kontak",
      children: [
        _buildListTile(
          Icons.email,
          "Tonald@gmail.com",
          showBorder: false,
          fontSize: 14,
        ),
        _buildListTile(
          Icons.check_circle,
          "Blok G No.1",
          showBorder: false,
          fontSize: 14,
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSectionContainer(
      title: "Akun",
      children: [
        _buildListTile(
          Icons.person,
          "Data Pribadi",
          hasArrow: true,
          isSingle: true,
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return _buildSectionContainer(
      title: "Pengaturan",
      children: [
        _buildListTile(
          Icons.settings,
          "Ubah Password",
          hasArrow: true,
          isFirst: true,
        ),
        _buildListTile(
          Icons.help,
          "FAQ dan Bantuan",
          hasArrow: true,
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required List<Widget> children,
  }) {
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(children: children),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile(
    IconData icon,
    String title, {
    bool hasArrow = false,
    bool isFirst = false,
    bool isLast = false,
    bool isSingle = false,
    bool showBorder = true,
    double fontSize = 16,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: (showBorder && !isLast && !isSingle)
            ? const Border(bottom: BorderSide(color: Colors.black12))
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0x337C68BE), // Light purple icon bg (0.2 opacity)
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF7C68BE)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (hasArrow)
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
