import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E2636),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 48,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Banner
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/banner.png', // ganti path sesuai banner kamu
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Verified / Unverified
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _statusBox(
                      colorDot: Colors.green,
                      label: 'Verified',
                      value: '40 Vehicles',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 1,
                    child: _statusBox(
                      colorDot: Colors.red,
                      label: 'Unverified',
                      value: '3 Vehicles',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Recently container (semua di dalam kotak)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Recently title + icon di dalam kotak
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Recently',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.refresh,
                            color: Colors.black87,
                            size: 20,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // List Recently
                      Expanded(
                        child: ListView(
                          children: const [
                            _recentItem(
                              plate: 'BP1234CD',
                              time: '19.30 • Out',
                            ),
                            SizedBox(height: 10),
                            _recentItem(
                              plate: 'BP5678EF',
                              time: '20.30 • In',
                            ),
                            SizedBox(height: 10),
                            _recentItem(),
                            SizedBox(height: 10),
                            _recentItem(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Box Verified / Unverified
  Widget _statusBox({
    required Color colorDot,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(radius: 5, backgroundColor: colorDot),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// Item Recently
class _recentItem extends StatelessWidget {
  final String? plate;
  final String? time;
  final String? imagePath;

  const _recentItem({
    this.plate,
    this.time,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Kotak image placeholder
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF334470),
              borderRadius: BorderRadius.circular(6),
              image: imagePath != null
                  ? DecorationImage(
                      image: AssetImage(imagePath!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imagePath == null
                ? const Icon(
                    Icons.image_outlined,
                    color: Colors.white70,
                    size: 18,
                  )
                : null,
          ),
          const SizedBox(width: 10),

          // Info plat & waktu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  plate ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time ?? '',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Icon arah
          const Icon(
            Icons.compare_arrows_rounded,
            color: Colors.black54,
            size: 18,
          ),
        ],
      ),
    );
  }
}
