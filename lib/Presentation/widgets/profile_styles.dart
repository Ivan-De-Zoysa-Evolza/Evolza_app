import 'package:flutter/material.dart';

class ProfileStyles {
  // Container Styles
  static BoxDecoration mainContainerDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.95),
        Colors.blue.shade50.withOpacity(0.95),
      ],
    ),
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      color: Colors.blue.shade200.withOpacity(0.5),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.2),
        blurRadius: 20,
        offset: Offset(0, 10),
        spreadRadius: 5,
      ),
    ],
  );

  static BoxDecoration profileIconDecoration = BoxDecoration(
    color: Colors.blue.shade600,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.3),
        blurRadius: 15,
        offset: Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration infoRowDecoration = BoxDecoration(
    color: Colors.white.withOpacity(0.7),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Colors.blue.shade200.withOpacity(0.5),
      width: 1,
    ),
  );

  static BoxDecoration infoIconDecoration = BoxDecoration(
    color: Colors.blue.shade100,
    borderRadius: BorderRadius.circular(8),
  );

  static BoxDecoration editButtonDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue.shade600, Colors.blue.shade800],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.4),
        blurRadius: 15,
        offset: Offset(0, 8),
      ),
    ],
  );

  // Text Styles
  static TextStyle profileTitleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade800,
    letterSpacing: 1.0,
  );

  static TextStyle infoLabelStyle = TextStyle(
    fontSize: 12,
    color: Colors.blue.shade600,
    fontWeight: FontWeight.w500,
  );

  static TextStyle infoValueStyle = TextStyle(
    fontSize: 16,
    color: Colors.blue.shade800,
    fontWeight: FontWeight.w600,
  );

  static TextStyle editButtonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Popup Styles
  static BoxDecoration popupContainerDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.95),
        Colors.blue.shade50.withOpacity(0.95),
      ],
    ),
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      color: Colors.blue.shade200.withOpacity(0.5),
      width: 1.5,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.2),
        blurRadius: 20,
        offset: Offset(0, 10),
        spreadRadius: 5,
      ),
    ],
  );

  static BoxDecoration popupIconDecoration = BoxDecoration(
    color: Colors.blue.shade600,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.3),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );

  static TextStyle popupTitleStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade800,
    letterSpacing: 0.5,
  );

  static TextStyle popupSubtitleStyle = TextStyle(
    fontSize: 14,
    color: Colors.blue.shade600,
    fontWeight: FontWeight.w500,
  );

  static TextStyle popupLabelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.blue.shade800,
  );

  static InputDecoration textFieldDecoration({
    required String hintText,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.8),
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.blue.shade400,
      ),
      prefixIcon: Icon(
        prefixIcon,
        color: Colors.blue.shade600,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade500, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade500, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  static BoxDecoration updateButtonDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.blue.shade600, Colors.blue.shade800],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.withOpacity(0.4),
        blurRadius: 12,
        offset: Offset(0, 6),
      ),
    ],
  );
} 