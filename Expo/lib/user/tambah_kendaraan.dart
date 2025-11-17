import 'package:flutter/material.dart';

class AddVehiclePage extends StatefulWidget {
  const AddVehiclePage({super.key});

  @override
  State<AddVehiclePage> createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final TextEditingController ownerController =
      TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController addressController =
      TextEditingController();

  String? vehicleType = "Value";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNav(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 49, 81, 117), Color.fromARGB(255, 139, 139, 139)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Vehicle",
                  style: TextStyle(
                    fontSize: 32,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 50),

                // Card putih konten
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.93),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFFB8A7FF),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Owner Name"),
                      _input(ownerController),

                      const SizedBox(height: 15),
                      _label("Plat Number"),
                      _input(plateController),

                      const SizedBox(height: 15),
                      _label("Vehicle Type"),
                      _dropdown(),

                      const SizedBox(height: 15),
                      _label("Address"),
                      _input(addressController),

                      const SizedBox(height: 15),
                      _label("Vehicle Image"),
                      _imageBox(),

                      const SizedBox(height: 25),
                      _submitButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Label field
  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      );

  // Input field
  Widget _input(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        hintText: "Value",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Dropdown
  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      value: vehicleType,
      items: ["Value", "Car", "Motorcycle", "Truck"]
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => vehicleType = v),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // Kotak gambar
  Widget _imageBox() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: const Color(0xFF1F2A47),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  // Tombol submit
  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1F2A47),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          "Submit",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  // Bottom navigation
  Widget _bottomNav() {
    return BottomAppBar(
      color: Colors.grey.shade200,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.menu, size: 30),
            Icon(Icons.home, size: 36),
            Icon(Icons.person, size: 30),
          ],
        ),
      ),
    );
  }
}
