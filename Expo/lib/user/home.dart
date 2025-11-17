import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 49, 81, 117),
              Color.fromARGB(255, 139, 139, 139),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning, Budi!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Welcome To Entrify",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Vehicle card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Your\nVehicle",
                              style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/user/data_kendaraan');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E2A47),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: const [
                                Text(
                                  "3",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Verified",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
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

                const SizedBox(height: 14),

                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/banner.png",
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Recently",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(
                      Icons.refresh_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView(
                    children: const [
                      _RecentItem(
                        plate: "BP1234CD",
                        time: "19.30",
                        isIn: false,
                      ),
                      _RecentItem(
                        plate: "BP5678EF",
                        time: "20.00",
                        isIn: true,
                      ),
                      _RecentItem(
                        plate: "BP1234CD",
                        time: "21.00",
                        isIn: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      color: const Color(0xFF1C2437),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Icon(Icons.search, color: Colors.white70, size: 26),
            Icon(Icons.home, color: Colors.white, size: 32),
            Icon(Icons.person_outline, color: Colors.white70, size: 26),
          ],
        ),
      ),
    );
  }
}

// =============================
// RECENT ITEM DENGAN NAV + ARGS
// =============================
class _RecentItem extends StatelessWidget {
  final String plate;
  final String time;
  final bool isIn;

  const _RecentItem({
    required this.plate,
    required this.time,
    required this.isIn,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/user/detail_kendaraan',
          arguments: {
            'ownerName': 'Budi Santoso',
            'platNumber': plate,
            'vehicleType': 'Motorcycle',
            'address': 'Jl. Merdeka No. 12',
          },
        );
      },
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF24355A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Text(
                            plate,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isIn ? Icons.login : Icons.logout,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      Text(
                        "$time • ${isIn ? 'In' : 'Out'}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Container(
                        height: 1,
                        color: Colors.white24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
