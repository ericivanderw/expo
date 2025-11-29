import 'dart:math';
import 'package:flutter/material.dart';
import 'package:expo/widgets/button.dart';

class SignInMergedPage extends StatefulWidget {
  const SignInMergedPage({super.key});

  @override
  State<SignInMergedPage> createState() => _SignInMergedPageState();
}

class _SignInMergedPageState extends State<SignInMergedPage> {
  bool _isSignInFormVisible = false;
  bool _showPassword = false;
  bool _rememberMe = true;

  void _toggleView() {
    setState(() {
      _isSignInFormVisible = !_isSignInFormVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // --- SIZES FOR VIEW 1 ---
    final logoSize1 = min(width * 0.80, 400.0);
    final titleFont = min(width * 0.065, 30.0);
    final subtitleFont = min(width * 0.038, 17.0);
    final buttonWidth1 = min(width * 0.85, 420.0);

    // --- SIZES FOR VIEW 2 ---
    final logoWidth2 = min(width * 0.60, 245.0);
    final cardMaxWidth = min(width, 490.0);
    final buttonMaxWidth2 = min(width * 0.80, 420.0);
    final iconColor = const Color.fromARGB(255, 185, 156, 190);

    return Scaffold(
      body: Stack(
        children: [
          // 1. ANIMATED BACKGROUND
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            width: width,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _isSignInFormVisible
                    ? [
                        const Color(0xFF2E1A47), // Deep Purple
                        const Color(0xFF1A0F29), // Darker Purple
                        Colors.black, // Black
                      ]
                    : [
                        const Color(0xFF8C6CCF),
                        const Color(0xFFA890D9),
                        const Color.fromARGB(255, 255, 255, 255),
                      ],
              ),
            ),
          ),

          // 2. VIEW 1 CONTENT (Fade out when form is visible)
          AnimatedOpacity(
            opacity: _isSignInFormVisible ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 600),
            child: IgnorePointer(
              ignoring: _isSignInFormVisible, // Disable clicks when hidden
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity, // Ensure full width for centering
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .center, // Explicitly center children
                      children: [
                        const Spacer(flex: 1),
                        // Placeholder for Logo (handled by AnimatedPositioned below)
                        SizedBox(height: logoSize1 * 0.8),
                        const Spacer(flex: 4),

                        // TITLE + SLOGAN
                        Column(
                          children: [
                            Text(
                              "Gate Smarter, Life Better.",
                              style: TextStyle(
                                fontSize: titleFont,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: height * 0.012),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: min(width * 0.65, 500),
                              ),
                              child: Text(
                                "Optimalisasi keamanan dan efisiensi dengan sistem akses otomatis.",
                                style: TextStyle(
                                  fontSize: subtitleFont,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.04),

                        SizedBox(
                          width: buttonWidth1,
                          child: CustomButton(
                            text: "Sign In",
                            onPressed: _toggleView,
                          ),
                        ),

                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. ANIMATED LOGO (Moves from Center to Top)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            top: _isSignInFormVisible
                ? height *
                      0.10 // Position for View 2
                : (height - (logoSize1 * 0.8)) / 2 -
                      (height *
                          0.2), // Approx center for View 1 (adjust as needed)
            left: _isSignInFormVisible
                ? (width - logoWidth2) / 2
                : (width - logoSize1) / 2,
            width: _isSignInFormVisible ? logoWidth2 : logoSize1,
            height: _isSignInFormVisible
                ? logoWidth2 * 0.8
                : logoSize1 * 0.8, // Maintain aspect ratio approx
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
          ),

          // 4. VIEW 2 FORM (Slide up from bottom)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            bottom: _isSignInFormVisible
                ? 0
                : -height * 0.6, // Hide below screen
            left: 0,
            right: 0,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardMaxWidth),
                child: Container(
                  width: width,
                  height: height * 0.52,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAEAEA),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(42),
                      topRight: Radius.circular(42),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.04),

                        // Back Button (Optional, to go back to View 1)
                        // GestureDetector(
                        //   onTap: _toggleView,
                        //   child: Icon(Icons.arrow_back, color: Colors.black54),
                        // ),
                        const Center(
                          child: Column(
                            children: [
                              Text(
                                "Sign In",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Sign in to my account",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: height * 0.035),

                        const Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // EMAIL FIELD
                        _inputField(
                          icon: Icons.email_outlined,
                          hint: "My Email",
                          iconColor: iconColor,
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // PASSWORD FIELD
                        _passwordField(iconColor),

                        const SizedBox(height: 12),

                        // REMEMBER ME
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (val) =>
                                      setState(() => _rememberMe = val ?? true),
                                  activeColor: Colors.deepPurple,
                                ),
                                const Text(
                                  "Remember Me",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const Text(
                              "Forgot Password",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.025),

                        // SIGN IN BUTTON
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: buttonMaxWidth2,
                              minHeight: 52,
                            ),
                            child: CustomButton(
                              text: "Sign In",
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/user/homepage',
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// TEXT FIELD COMPONENT
  Widget _inputField({
    required IconData icon,
    required String hint,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1.3),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "My Email",
                hintStyle: TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PASSWORD FIELD
  Widget _passwordField(Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1.3),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              obscureText: !_showPassword,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "My Password",
                hintStyle: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showPassword = !_showPassword),
            child: Icon(
              _showPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
