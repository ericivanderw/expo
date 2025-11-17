import 'package:flutter/material.dart';

class VerifyPage extends StatelessWidget {
  const VerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Verify",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _sectionCard(
                    title: "Verified",
                    items: const [
                      VehicleItem(plate: "BP1234CD", type: "Car", owner: "Budi"),
                      VehicleItem(plate: "BP5678EF", type: "Motorcycle", owner: "Nana"),
                    ],
                    onSeeMore: () {
                      Navigator.pushNamed(context, '/admin/verified');
                    },
                  ),

                  SizedBox(height: 25),

                  _sectionCard(
                    title: "Unverified",
                    items: const [
                      VehicleItem(plate: "BP8888DE", type: "Motorcycle", owner: "Lala"),
                      VehicleItem(plate: "BP5656FG", type: "Car", owner: "Banu"),
                    ],
                    onSeeMore: () {
                      Navigator.pushNamed(context, '/admin/unverified');
                    },
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<VehicleItem> items,
    required VoidCallback onSeeMore,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 15),

          ...items.map((e) => _vehicleTile(e)),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onSeeMore,
              child: Text(
                "See More »",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _vehicleTile(VehicleItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.plate,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${item.type} • ${item.owner}",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        ],
      ),
    );
  }
}

class VehicleItem {
  final String plate;
  final String type;
  final String owner;

  const VehicleItem({
    required this.plate,
    required this.type,
    required this.owner,
  });
}
