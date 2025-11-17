import 'package:flutter/material.dart';

class HomeUIScreen extends StatelessWidget {
  const HomeUIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNav(),
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
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // SEARCH BAR
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.white70),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search",
                            hintStyle: TextStyle(color: Colors.white60),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // TODAY + DATE ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Today",
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "01/02/2025",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // TODAY LIST CONTAINER
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      vehicleItem(
                        context: context,
                        plate: "BP1234CD",
                        time: "19.30 • Out",
                        icon: Icons.logout,
                      ),
                      vehicleItem(
                        context: context,
                        plate: "BP5678EF",
                        time: "19.30 • In",
                        icon: Icons.login,
                        highlight: true,
                      ),

                      emptyVehicle(),
                      const SizedBox(height: 8),

                      // SEE MORE
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/admin/detail_kendaraan');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              "See More »",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // CALENDAR TITLE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "February",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "2025",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 16),

                // CALENDAR BOX
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: calendarWidget(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------
  // VEHICLE ITEM
  // -----------------------------
  Widget vehicleItem({
  required BuildContext context,
  required String plate,
  required String time,
  required IconData icon,
  bool highlight = false,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/admin/detail_user');
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: highlight ? const Color(0xFF3C76FF) : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // TEXT
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plate,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          ),
          const Icon(Icons.chevron_right, color: Colors.black87),
        ],
      ),
    ),
  );
}


  Widget emptyVehicle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerRight,
      child: const Padding(
        padding: EdgeInsets.only(right: 12),
        child: Icon(Icons.chevron_right, color: Colors.black87),
      ),
    );
  }

  // -----------------------------
  // CALENDAR STATIC
  // -----------------------------
  Widget calendarWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Sun", style: TextStyle(color: Colors.red)),
              Text("Mon"),
              Text("Tue"),
              Text("Wed"),
              Text("Thu"),
              Text("Fri"),
              Text("Sat", style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),

        const SizedBox(height: 12),

        buildCalendarRow(["", "", "", "", "", "", "1"]),
        buildCalendarRow(["2", "3", "4", "5", "6", "7", "8"]),
        buildCalendarRow(["9", "10", "11", "12", "13", "14", "15"]),
        buildCalendarRow(["16", "17", "18", "19", "20", "21", "22"]),
        buildCalendarRow(["23", "24", "25", "26", "27", "28", ""]),
      ],
    );
  }

  Widget buildCalendarRow(List<String> days) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days
            .map((d) => SizedBox(
                  width: 25,
                  child: Text(
                    d,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),
                ))
            .toList(),
      ),
    );
  }

  // -----------------------------
  // BOTTOM NAV
  // -----------------------------
  Widget buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Icon(Icons.menu, size: 28),
          Icon(Icons.home_outlined, size: 32),
          Icon(Icons.person_outline, size: 28),
        ],
      ),
    );
  }
}
