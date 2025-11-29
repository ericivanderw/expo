import 'package:flutter/material.dart';

class UserBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const UserBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87, // Background hitam full width
      child: SafeArea(
        top:
            false, // Jangan berikan padding atas, hanya bawah (untuk HP kekinian)
        child: Column(
          // KUNCI 1: mainAxisSize min MENCEGAH navbar memenuhi layar vertikal
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                // KUNCI 2: Batasi lebar maks 500, tapi width tetap mengikuti layar jika < 500
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // KUNCI 3: Expanded MEMAKSA item berbagi ruang rata & mencegah overflow kesamping
                    Expanded(child: _buildNavItem(Icons.home, "Home", 0)),
                    Expanded(
                      child: _buildNavItem(
                        Icons.announcement_outlined,
                        "Pengumuman",
                        1,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(Icons.list_alt_outlined, "Log", 2),
                    ),
                    Expanded(
                      child: _buildNavItem(Icons.person_outline, "Profil", 3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min, // Pastikan column item juga minimalis
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? Colors.white : Colors.white70,
          ),
          const SizedBox(height: 4),

          // KUNCI 4: FittedBox mencegah teks overflow/nabrak jika layar SANGAT kecil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1, // Pastikan cuma 1 baris
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Colors.white70,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
