import 'package:flutter/material.dart';

class CustomColors {
  // Main brand color
  // static const Color mainColor = Color(0xFFE68200);
  //static const Color mainColor = Color(0xFF3A8726);
  static const Color mainColor = Color(0xFFFF9576);
  // static const Color mainColor = Color(0xFFFFA600);
  static const Color purble = Color(0xFF974B6A);
  // static const Color selectedNavBarColor = Color(0xFFFFA600);
  static const Color selectedNavBarColor = Color(0xFF974B6A);
  static const Color mintGold = Color(0xFFFFD500);
  //static const Color mintGreen = Color(0xFF52D0B3);
  static const Color mintBlue = Color(0xFF2CBEBB);

  static const Color softDarkRose = Color(0xFFF3E4EA);

  // Backgrounds
  //static const Color lightBackground = Color(0xFFEFEBE5);
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);

  // Card colors
  static const Color lightCard = Colors.white;
  static const Color darkCard =
      Color(0xFF252525); // slightly elevated dark surface

  // Text
  static const Color textBlack = Colors.black;
  static const Color textBlack87 = Color(0xFF383D4A);
  static const Color textBlack54 = Color(0xFF606676);
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;
  static const Color textWhite60 = Colors.white60;

  // Bottom navigation
  static const Color bottomNavLightBackground = Colors.white;
  static const Color bottomNavDarkBackground = Color(0xFF1E1E1E);
  static const Color bottomNavUnselectedLight = Color(0xFF606676);
  static const Color bottomNavUnselectedDark = Colors.white70;
  static const Color disabledToggleColor = Color(0xFFBCC1CA);

  // Dividers
  static final Color dividerLight = Colors.grey.shade300;
  static final Color dividerDark = Colors.grey.shade800;

  // Shadows (if needed for cards)
  static final Color shadowLight = Colors.grey.withOpacity(0.1);
  static const Color borderColor = Color(0x286A6A6A);
  static final Color shadowDark = Colors.black.withOpacity(0.3);

  // Premium Gradients for Packages
  static const List<List<Color>> packageGradients = [
    [Color(0xFF6A11CB), Color(0xFF2575FC)], // 1. Deep Blue/Purple
    [Color(0xFFFF512F), Color(0xFFDD2476)], // 2. Vibrant Sunset
    [Color(0xFF11998E), Color(0xFF38EF7D)], // 3. Fresh Green/Teal
    [Color(0xFFF093FB), Color(0xFFF5576C)], // 4. Soft Pink/Rose
    [Color(0xFF4FACFE), Color(0xFF00F2FE)], // 5. Sky Blue/Azure
    [Color(0xFF43E97B), Color(0xFF38F9D7)], // 6. Mint Green
    [Color(0xFFFA709A), Color(0xFFFEE140)], // 7. Peach/Yellow
    [Color(0xFF30CFD0), Color(0xFF330867)], // 8. Deep Teal/Indigo
    [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // 9. Vivid Purple
    [Color(0xFF00C6FF), Color(0xFF0072FF)], // 10. Ocean Blue
    [Color(0xFFF9D423), Color(0xFFFF4E50)], // 11. Burning Orange
    [Color(0xFFE14FED), Color(0xFF2B86C5)], // 12. Cosmic Purple
    [Color(0xFFB721FF), Color(0xFF21D4FD)], // 13. Electric Blue
    [Color(0xFFF6D365), Color(0xFFFDA085)], // 14. Soft Peach
    [Color(0xFF09203F), Color(0xFF537895)], // 15. Midnight Blue
    [Color(0xFF667EEA), Color(0xFF764BA2)], // 16. Indigo Violet
  ];
}
