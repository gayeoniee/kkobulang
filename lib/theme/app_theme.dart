import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Core palette (로고 기반)
  static const cream = Color(0xFFFFF8EF);
  static const creamDark = Color(0xFFFFF0DC);
  static const peach = Color(0xFFF2A58E);
  static const peachLight = Color(0xFFFDEEE8);
  static const peachDark = Color(0xFFE8896E);
  static const teal = Color(0xFF5BBCB0);
  static const tealLight = Color(0xFFD6F0ED);
  static const tealDark = Color(0xFF3A9E92);
  static const brown = Color(0xFF3D2B1F);
  static const brownMid = Color(0xFF7A5C4A);
  static const brownLight = Color(0xFFB89585);
  static const green = Color(0xFF6BBF5F);
  static const greenLight = Color(0xFFD9F0D6);
  static const border = Color(0xFFEDD5C5);
  static const surface = Color(0xFFF5EBE5);

  // Curl type colors
  static const type2 = Color(0xFFF5D76E);
  static const type2Bg = Color(0xFFFFFBE6);
  static const type3 = Color(0xFFF4A27B);
  static const type3Bg = Color(0xFFFFF3EC);
  static const type4 = Color(0xFFE87070);
  static const type4Bg = Color(0xFFFFF0F0);
  static const star = Color(0xFFF5C842);

  static Color curlTypeColor(String type) {
    final n = int.tryParse(type.isEmpty ? '3' : type[0]) ?? 3;
    if (n == 2) return type2;
    if (n == 4) return type4;
    return type3;
  }

  static Color curlTypeBg(String type) {
    final n = int.tryParse(type.isEmpty ? '3' : type[0]) ?? 3;
    if (n == 2) return type2Bg;
    if (n == 4) return type4Bg;
    return type3Bg;
  }
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.peach,
        background: AppColors.cream,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.cream,
      textTheme: GoogleFonts.notoSansKrTextTheme().apply(
        bodyColor: AppColors.brown,
        displayColor: AppColors.brown,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.brown),
        titleTextStyle: GoogleFonts.notoSansKr(
          color: AppColors.brown,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.peach,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w700),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.peach, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: GoogleFonts.notoSansKr(color: AppColors.brownLight, fontSize: 14),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.peach,
        unselectedItemColor: AppColors.brownLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.notoSansKr(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }
}
