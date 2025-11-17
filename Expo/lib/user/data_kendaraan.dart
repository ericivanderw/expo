import 'package:flutter/material.dart';

class VehicleDataPage extends StatelessWidget {
  const VehicleDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SEARCH BAR ---------------------------------------------------
                Container(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black54, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.black38),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // VERIFIED -----------------------------------------------------
                const Text(
                  "Verified",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),

                VehicleItem(plate: "BP1234CD", type: "Car"),
                VehicleItem(plate: "BP5678EF", type: "Motorcycle"),
                VehicleItem(plate: "BP1234CD", type: "Car"),

                const SizedBox(height: 28),

                // UNVERIFIED --------------------------------------------------
                const Text(
                  "Unverified • Waiting",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),

                VehicleItem(plate: "BP1234CD", type: "Car"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VehicleItem extends StatelessWidget {
  final String plate;
  final String type;

  const VehicleItem({
    super.key,
    required this.plate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/user/detail_kendaraan",
          arguments: {
            "plate": plate,
            "type": type,
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Thumbnail box
                Container(
                  width: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2C4B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(width: 14),

                // Text + arrow
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            plate,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),

                          const Spacer(),

                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.white70,
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      Text(
                        type,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
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
