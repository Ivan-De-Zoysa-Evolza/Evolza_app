import 'package:flutter/material.dart';

class AuthStyles {
  static const gradientColors = [
    Color(0xFF1e3c72),
    Color(0xFF2a5298),
    Color(0xFF3b82f6),
  ];

  static const gradientStops = [0.0, 0.5, 1.0];

  static BoxDecoration get containerDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      );

  static BoxDecoration get formContainerDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      );

  static InputDecoration get textFieldDecoration => InputDecoration(
        filled: true,
        fillColor: const Color(0xFFf9fafb),
        hintStyle: const TextStyle(
          color: Color(0xFF9ca3af),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFe5e7eb),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFe5e7eb),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFF3b82f6),
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      );

  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3b82f6),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        shadowColor: const Color(0xFF3b82f6).withOpacity(0.3),
      );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1e3c72),
    letterSpacing: 1,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF6b7280),
    letterSpacing: 0.5,
  );

  static const TextStyle formTitleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF1e3c72),
  );

  static const TextStyle formSubtitleStyle = TextStyle(
    fontSize: 14,
    color: Color(0xFF6b7280),
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF374151),
  );

  static const TextStyle linkStyle = TextStyle(
    color: Color(0xFF3b82f6),
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textStyle = TextStyle(
    color: Color(0xFF6b7280),
    fontSize: 14,
  );
} 