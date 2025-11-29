import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth =
            (constraints.maxWidth.isFinite && constraints.maxWidth > 0)
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width * 0.8;

        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) {
            setState(() => _pressed = false);
            widget.onPressed();
          },
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: SizedBox(
              width: buttonWidth,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _pressed
                        ? [
                            const Color(0xFF6D4FC2),
                            const Color(0xFF361D77),
                          ]
                        : [
                            const Color(0xFF8C6CCF),
                            const Color(0xFF5A3FAE),
                          ],
                  ),
                  boxShadow: _pressed
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            offset: const Offset(2, 2),
                            blurRadius: 6,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.25),
                            offset: const Offset(-2, -2),
                            blurRadius: 6,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            offset: const Offset(4, 4),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            offset: const Offset(-4, -4),
                            blurRadius: 8,
                          ),
                        ],
                ),
                child: Center(
                  child: Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
