import 'package:flutter/material.dart';
import 'package:expo/widgets/appbarback.dart';
import 'package:expo/admin/detail_pengumuman.dart';
import 'package:expo/admin/tambah_pengumuman.dart';

class DaftarPengumumanPage extends StatelessWidget {
  const DaftarPengumumanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const AppBarBack(title: 'Daftar Pengumuman'),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildAnnouncementItem(
                'Kegiatan Bulanan - Gotong Royong Rulaman',
                '19 Jan 2024',
                'assets/gotongroyong.png',
                context,
              ),
              const SizedBox(height: 12),
              _buildAnnouncementItem(
                'Kegiatan Bulanan - Gotong Royong Rulaman',
                '19 Jan 2024',
                'assets/gotongroyong.png',
                context,
              ),
              const SizedBox(height: 12),
              _buildAnnouncementItem(
                'Kegiatan Bulanan - Gotong Royong Rulaman',
                '19 Jan 2024',
                'assets/gotongroyong.png',
                context,
              ),
              const SizedBox(height: 12),
              _buildAnnouncementItem(
                'Kegiatan Bulanan - Gotong Royong Rulaman',
                '19 Jan 2024',
                'assets/gotongroyong.png',
                context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnouncementItem(
    String title,
    String date,
    String imagePath,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailPengumumanPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TambahPengumumanPage(),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.grey.shade700,
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () {
                    _showDeleteDialog(context);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: Colors.red.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengumuman'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus pengumuman ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );
  }
}
