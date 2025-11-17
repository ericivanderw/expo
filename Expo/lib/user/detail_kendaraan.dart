import 'package:flutter/material.dart';

class VehicleDetailPage extends StatelessWidget {
  static const routeName = '/data_kendaraan';

  const VehicleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ====== TERIMA ARGUMENTS ======
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    final ownerName = args['ownerName'] ?? '-';
    final platNumber = args['platNumber'] ?? '-';
    final vehicleType = args['vehicleType'] ?? '-';
    final address = args['address'] ?? '-';

    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "My Vehicle",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 50),

                Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Detail Information",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 26),

                      _infoRow("Owner’s Name", ownerName),
                      const SizedBox(height: 14),

                      _infoRow("Plat Number", platNumber),
                      const SizedBox(height: 14),

                      _infoRow("Vehicle Type", vehicleType),
                      const SizedBox(height: 14),

                      _infoRow("Address", address),
                      const SizedBox(height: 22),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              color: const Color(0xFF24355A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          const SizedBox(width: 20),

                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 45, top: 45),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 85,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE1D87B),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  Container(
                                    width: 85,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFB03A2E),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
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

  Widget _infoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
