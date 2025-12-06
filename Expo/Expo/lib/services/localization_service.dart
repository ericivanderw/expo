import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;
  LocalizationService._internal();

  final _storage = GetStorage();
  final ValueNotifier<Locale> localeNotifier = ValueNotifier(
    const Locale('id', 'ID'),
  );

  void init() {
    final String? langCode = _storage.read('language_code');
    if (langCode != null) {
      localeNotifier.value = Locale(langCode);
    }
  }

  void changeLocale(String langCode) {
    localeNotifier.value = Locale(langCode);
    _storage.write('language_code', langCode);
  }

  String translate(String key) {
    final String lang = localeNotifier.value.languageCode;
    return _localizedValues[lang]?[key] ?? key;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'id': {
      'tentang_saya': 'Tentang Saya',
      'penghuni': 'Penghuni',
      'kendaraanku': 'Kendaraanku',
      'unverified': 'Belum Verifikasi',
      'verified': 'Terverifikasi',
      'kontak': 'Kontak',
      'akun': 'Akun',
      'data_pribadi': 'Data Pribadi',
      'pengaturan': 'Pengaturan',
      'visi_misi': 'Visi Misi',
      'ketentuan_privasi': 'Ketentuan & Privasi',
      'keluar': 'Keluar',
      'pilih_bahasa': 'Pilih Bahasa',
      'bahasa': 'Bahasa',
      'batal': 'Batal',
      'halo': 'Halo',
      'selamat_datang': 'Selamat Datang di Entrify',
      'menu_utama': 'Menu Utama',
      'daftar_kendaraan': 'Daftar\nKendaraan',
      'riwayat_kendaraan': 'Riwayat\nKendaraan',
      'pengumuman': 'Pengumuman',
      'see_more': 'Lihat Semua',
      'info_pengumuman': 'Informasi Pengumuman Bulan Ini',
      'tidak_ada_pengumuman': 'Tidak ada pengumuman',
      'data_keluar_masuk': 'Data Kendaraan Keluar-Masuk.',
      'search_placeholder': 'Cari plat/tipe',
      'tidak_ada_data': 'Tidak ada data ditemukan',
      'tanggal': 'Tanggal',
      'status': 'Status',
      'jenis': 'Jenis',
      'masuk': 'Masuk',
      'keluar_status': 'Keluar', // 'keluar' is already used for logout
      'motor': 'Motor',
      'mobil': 'Mobil',
      'semua': 'Semua',
      'hapus_filter': 'Hapus Filter',
      'pilih': 'Pilih',
      'lihat_detail': 'Lihat Detail',
      'tambah_kendaraan': 'Tambah Kendaraan',
      'pending': 'Menunggu',
      'rejected': 'Ditolak',
      'periode': 'Periode',
      'daftar_pengumuman': 'Daftar Pengumuman',
      'informasi_pengumuman': 'Informasi Pengumuman',
      'visi_misi_content':
          'Visi:\nMenjadi platform manajemen hunian terdepan yang memudahkan interaksi antara pengelola dan penghuni.\n\nMisi:\n1. Memberikan layanan yang transparan dan efisien.\n2. Meningkatkan keamanan dan kenyamanan lingkungan.\n3. Membangun komunitas yang harmonis.',
      'ketentuan_privasi_content':
          '1. Data Pengguna:\nKami menjaga kerahasiaan data pribadi Anda dan tidak akan membagikannya kepada pihak ketiga tanpa izin.\n\n2. Penggunaan Aplikasi:\nAplikasi ini digunakan untuk keperluan manajemen hunian dan komunikasi antar warga.\n\n3. Keamanan:\nKami berkomitmen untuk menjaga keamanan data dan transaksi dalam aplikasi ini.',
      'tutup': 'Tutup',
      'detail_kendaraan': 'Detail Kendaraan',
      'nama_pemilik': 'Nama Pemilik',
      'plat_kendaraan': 'Plat Kendaraan',
      'jenis_kendaraan': 'Jenis Kendaraan',
      'tanggal_waktu': 'Tanggal & Waktu',
      'detail_pengumuman_title': 'Detail Pengumuman',
      'uploaded': 'Diunggah',
      'deskripsi': 'Deskripsi',
      'tanggal_kegiatan': 'Tanggal Kegiatan',
      'uploaded_by': 'Diunggah Oleh',
      'pengurus_keamanan': 'Pengurus Keamanan',
      'memuat': 'Memuat...',
    },
    'en': {
      'tentang_saya': 'About Me',
      'penghuni': 'Resident',
      'kendaraanku': 'My Vehicles',
      'unverified': 'Unverified',
      'verified': 'Verified',
      'kontak': 'Contact',
      'akun': 'Account',
      'data_pribadi': 'Personal Data',
      'pengaturan': 'Settings',
      'visi_misi': 'Vision & Mission',
      'ketentuan_privasi': 'Terms & Privacy',
      'keluar': 'Logout',
      'pilih_bahasa': 'Select Language',
      'bahasa': 'Language',
      'batal': 'Cancel',
      'halo': 'Hello',
      'selamat_datang': 'Welcome to Entrify',
      'menu_utama': 'Main Menu',
      'daftar_kendaraan': 'Vehicle\nList',
      'riwayat_kendaraan': 'Vehicle\nHistory',
      'pengumuman': 'Announcements',
      'see_more': 'See All',
      'info_pengumuman': 'Announcement Info',
      'tidak_ada_pengumuman': 'No announcements',
      'data_keluar_masuk': 'In/Out Data',
      'search_placeholder': 'Search plate/type',
      'tidak_ada_data': 'No data found',
      'tanggal': 'Date',
      'status': 'Status',
      'jenis': 'Type',
      'masuk': 'In',
      'keluar_status': 'Out',
      'motor': 'Motorcycle',
      'mobil': 'Car',
      'semua': 'All',
      'hapus_filter': 'Clear Filter',
      'pilih': 'Select',
      'lihat_detail': 'View Details',
      'tambah_kendaraan': 'Add Vehicle',
      'pending': 'Pending',
      'rejected': 'Rejected',
      'periode': 'Period',
      'daftar_pengumuman': 'Announcement List',
      'informasi_pengumuman': 'Announcement Information',
      'visi_misi_content':
          'Vision:\nTo be the leading residential management platform that facilitates interaction between management and residents.\n\nMission:\n1. Provide transparent and efficient services.\n2. Improve environmental security and comfort.\n3. Build a harmonious community.',
      'ketentuan_privasi_content':
          '1. User Data:\nWe maintain the confidentiality of your personal data and will not share it with third parties without permission.\n\n2. App Usage:\nThis application is used for residential management and communication between residents.\n\n3. Security:\nWe are committed to maintaining the security of data and transactions in this application.',
      'tutup': 'Close',
      'detail_kendaraan': 'Vehicle Detail',
      'nama_pemilik': 'Owner Name',
      'plat_kendaraan': 'Vehicle Plate',
      'jenis_kendaraan': 'Vehicle Type',
      'tanggal_waktu': 'Date & Time',
      'detail_pengumuman_title': 'Announcement Detail',
      'uploaded': 'Uploaded',
      'deskripsi': 'Description',
      'tanggal_kegiatan': 'Event Date',
      'uploaded_by': 'Uploaded By',
      'pengurus_keamanan': 'Security Admin',
      'memuat': 'Loading...',
    },
    'zh': {
      'tentang_saya': '关于我',
      'penghuni': '居民',
      'kendaraanku': '我的车辆',
      'unverified': '未验证',
      'verified': '已验证',
      'kontak': '联系方式',
      'akun': '账户',
      'data_pribadi': '个人资料',
      'pengaturan': '设置',
      'visi_misi': '愿景与使命',
      'ketentuan_privasi': '条款与隐私',
      'keluar': '退出',
      'pilih_bahasa': '选择语言',
      'bahasa': '语言',
      'batal': '取消',
      'halo': '你好',
      'selamat_datang': '欢迎来到 Entrify',
      'menu_utama': '主菜单',
      'daftar_kendaraan': '车辆\n列表',
      'riwayat_kendaraan': '车辆\n历史',
      'pengumuman': '公告',
      'see_more': '查看更多',
      'info_pengumuman': '本月公告信息',
      'tidak_ada_pengumuman': '暂无公告',
      'data_keluar_masuk': '车辆出入数据',
      'search_placeholder': '搜索车牌/类型',
      'tidak_ada_data': '未找到数据',
      'tanggal': '日期',
      'status': '状态',
      'jenis': '类型',
      'masuk': '入',
      'keluar_status': '出',
      'motor': '摩托车',
      'mobil': '汽车',
      'semua': '全部',
      'hapus_filter': '清除筛选',
      'pilih': '选择',
      'lihat_detail': '查看详情',
      'tambah_kendaraan': '添加车辆',
      'pending': '待处理',
      'rejected': '已拒绝',
      'periode': '期间',
      'daftar_pengumuman': '公告列表',
      'informasi_pengumuman': '公告详情',
      'visi_misi_content':
          '愿景：\n成为促进管理者与居民互动的领先住宅管理平台。\n\n使命：\n1. 提供透明高效的服务。\n2. 提高环境安全和舒适度。\n3. 建立和谐社区。',
      'ketentuan_privasi_content':
          '1. 用户数据：\n我们要保护您的个人数据机密性，未经许可不会与第三方共享。\n\n2. 应用使用：\n此应用程序用于住宅管理和居民之间的沟通。\n\n3. 安全：\n我们致力于维护此应用程序中数据和交易的安全。',
      'tutup': '关闭',
      'detail_kendaraan': '车辆详情',
      'nama_pemilik': '车主姓名',
      'plat_kendaraan': '车牌号',
      'jenis_kendaraan': '车辆类型',
      'tanggal_waktu': '日期和时间',
      'detail_pengumuman_title': '公告详情',
      'uploaded': '上传于',
      'deskripsi': '描述',
      'tanggal_kegiatan': '活动日期',
      'uploaded_by': '上传者',
      'pengurus_keamanan': '安全管理员',
      'memuat': '加载中...',
    },
  };
}

// Helper function for easier access
String tr(String key) => LocalizationService().translate(key);
