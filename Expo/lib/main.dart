import 'package:flutter/material.dart';

// IMPORT ADMIN PAGES
import 'admin/home.dart';
import 'admin/verif.dart';
import 'admin/verified.dart';
import 'admin/unverified.dart';
import 'admin/data_kendaraan.dart';
import 'admin/detail_kendaraan.dart';
import 'admin/detail_user.dart';

// IMPORT USER PAGES (opsional, jika ingin routing user juga)
import 'user/home.dart';
import 'user/data_kendaraan.dart';
import 'user/detail_kendaraan.dart';
import 'user/tambah_kendaraan.dart';
import 'user/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: '/admin/home',

      routes: {
        // ----------------------- ADMIN ROUTES -----------------------
        '/admin/home': (context) => const AdminHome(),
        '/admin/verif': (context) => const VerifyPage(),
        '/admin/verified': (context) => const VerifiedPage(),
        '/admin/unverified': (context) => const unverifiedPage(),
        '/admin/data_kendaraan': (context) => HomeUIScreen(),
        '/admin/detail_kendaraan': (context) => TodayPage(),
        '/admin/detail_user': (context) => DetailInformationPage(),

        // ----------------------- USER ROUTES (opsional) -------------
        '/user/home': (context) => const HomePage(),
        '/user/data_kendaraan': (context) => VehicleDataPage(),
        '/user/detail_kendaraan': (context) => VehicleDetailPage(),
        '/user/tambah_kendaraan': (context) => AddVehiclePage(),
        '/user/profile': (context) => AccountPage(),
      },
    );
  }
}
