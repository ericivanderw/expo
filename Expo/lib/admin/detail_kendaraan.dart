import 'package:flutter/material.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

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
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  const Text(
                    "Today",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // DATE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "01/02/2025",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // SEARCH BAR
                  Container(
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color: Colors.black38,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        const Icon(Icons.search, color: Colors.black54),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // LIST ITEMS
                  buildRecentItem(
                    context: context,
                    plate: "BP1234CD",
                    time: "19.30 • Out",
                    icon: Icons.logout,
                  ),

                  buildRecentItem(
                    context: context,
                    plate: "BP5678EF",
                    time: "19.30 • In",
                    icon: Icons.login,
                  ),

                  buildRecentItem(context: context),
                  buildRecentItem(context: context),
                  buildRecentItem(context: context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =================== ITEM WIDGET ===================
  Widget buildRecentItem({
    required BuildContext context,
    String? plate,
    String? time,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: () {
        if (plate != null) {
          Navigator.pushNamed(
            context,
            '/admin/detail_user',
            arguments: {
              'plate': plate,
              'time': time ?? "",
            },
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE5E5E5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            // BLUE SQUARE
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: const Color(0xFF2F3E5A),
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            const SizedBox(width: 14),

            // TEXT
            Expanded(
              child: (plate == null)
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              plate,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            if (icon != null)
                              Icon(icon, size: 18, color: Colors.black87),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          time ?? "",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
            ),

            if (plate != null)
              const Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
