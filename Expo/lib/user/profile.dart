import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Account",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_outline, color: Colors.black87),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // PERSONAL INFO CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Personal Info",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Edit",
                            style: TextStyle(
                              color: Colors.blue.shade200,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      buildInfoItem(
                        icon: Icons.person_outline,
                        title: "Name",
                        value: "Budi",
                      ),
                      buildInfoItem(
                        icon: Icons.mail_outline,
                        title: "Email",
                        value: "budi32123@gmail.com",
                      ),
                      buildInfoItem(
                        icon: Icons.phone_outlined,
                        title: "Phone Number",
                        value: "+62 812 7575 8888",
                      ),
                      buildInfoItem(
                        icon: Icons.home_outlined,
                        title: "Home Address",
                        value: "Blok G No.1",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                const Padding(
                  padding: EdgeInsets.only(left: 10), // geser ke kanan
                  child: Text(
                    "Help and Feedback",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                buildMenuItem(
                  icon: Icons.info_outline,
                  title: "Help",
                ),
                buildMenuItem(
                  icon: Icons.chat_bubble_outline,
                  title: "Contact Us",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // PERSONAL INFO ITEM
  // ----------------------------------------------------
  Widget buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Icon(icon, color: Colors.white, size: 25),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    )),
                const SizedBox(height: 2),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 4),
                    Container(height: 1, color: Colors.white38),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 30),
      child: Row(
        children: [
          Icon(icon, color: Colors.black, size: 50),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.white70),
                  ],
                ),
                const SizedBox(height: 6),
                Container(height: 1, color: Colors.white38),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
