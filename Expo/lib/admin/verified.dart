import 'package:flutter/material.dart';

class VerifiedPage extends StatelessWidget {
  const VerifiedPage({super.key});

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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    "Verified",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Search bar
                  _searchBar(),

                  const SizedBox(height: 20),

                  // Background yang menyesuaikan tinggi isi
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        _vehicleTile(
                          plate: "BP1234CD",
                          type: "Car",
                          owner: "Budi",
                        ),
                        _vehicleTile(
                          plate: "BP5678EF",
                          type: "Motorcycle",
                          owner: "Nana",
                        ),
                        _emptyTile(),
                        _emptyTile(),
                        _emptyTile(),
                        _emptyTile(),
                        _emptyTile(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Bottom Navbar
      bottomNavigationBar: _bottomNavbar(),
    );
  }

  // ---------------------------- WIDGETS ----------------------------

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: const [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
          Icon(Icons.search),
        ],
      ),
    );
  }

  Widget _vehicleTile({
    required String plate,
    required String type,
    required String owner,
  }) {
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
                plate,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "$type • $owner",
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

  Widget _emptyTile() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavbar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      elevation: 10,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black54,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 30),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: '',
        ),
      ],
    );
  }
}
