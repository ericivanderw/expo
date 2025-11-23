import 'package:flutter/material.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER ----------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Home",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Icon(Icons.notifications_none,
                          color: Colors.white, size: 30),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // BANNER IMAGE ---------------------------------------------
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: AssetImage("assets/banner.png"),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                        Colors.black38,
                          BlendMode.darken,   
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // STATUS CHIP ROW -----------------------------------------
                 Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/admin/verif');
                        },
                        child: buildStatusChip(
                          label: "Verified",
                          count: "40 Vehicles",
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/admin/verif');
                        },
                        child: buildStatusChip(
                          label: "Unverified",
                          count: "3 Vehicles",
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),


                  const SizedBox(height: 25),

                  // RECENTLY SECTION ----------------------------------------
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6D6D6),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              "Recently",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.refresh, size: 20, color: Colors.black),
                          ],
                        ),

                        const SizedBox(height: 20),
                        buildRecentItem(
                          context,
                          plate: "BP1234CD",
                          time: "19.30 • Out",
                        ),
                        buildRecentItem(
                          context,
                          plate: "BP5678EF",
                          time: "20.30 • In",
                        ),
                        buildRecentItem(context),
                        buildRecentItem(context),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


// ===========================================================================
// STATUS CHIP
// ===========================================================================
  Widget buildStatusChip({
    required String label,
    required String count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT SIDE TEXT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                count,
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),

          // RIGHT SIDE STATUS CIRCLE
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }


// ===========================================================================
// RECENT ITEM
// ===========================================================================
  Widget buildRecentItem(BuildContext context, {String? plate, String? time}) {
  return GestureDetector(
    onTap: plate == null
        ? null
        : () {
            Navigator.pushNamed(
              context,
              "/admin/data_kendaraan",
              arguments: {
                "plate": plate,
                "time": time,
              },
            );
          },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFF2F3E5A),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: (plate == null)
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plate,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        time ?? "",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
          ),
          if (plate != null)
            const Icon(Icons.arrow_forward, size: 22, color: Colors.black87),
        ],
      ),
    ),
  );
}

}
