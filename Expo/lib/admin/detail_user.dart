import 'package:flutter/material.dart';

class DetailInformationPage extends StatelessWidget {
  const DetailInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hilangkan warna default supaya gradient terlihat penuh
      backgroundColor: Colors.transparent,

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 49, 81, 117),
              Color.fromARGB(255, 139, 139, 139),
            ],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // === TODAY TEXT ===
                const Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                // === DATE RIGHT SIDE ===
                Align(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    "01/02/2025",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // === MAIN CARD ===
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [

                      const Text(
                        "Detail Information",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 24),

                      infoTile("Owner's Name", "Budi"),
                      const SizedBox(height: 12),

                      infoTile("Plat Number", "BP1234CD"),
                      const SizedBox(height: 12),

                      infoTile("Vehicle Type", "Car"),
                      const SizedBox(height: 12),

                      infoTile("Status", "In"),
                      const SizedBox(height: 12),

                      infoTile("Time", "19.30"),
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

  // ======== FIELD TEMPLATE =========
  Widget infoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
