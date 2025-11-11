import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextStyle title = GoogleFonts.lora(
    fontWeight: FontWeight.w600,
    fontSize: 32,
  );
  static TextStyle subtitle = GoogleFonts.playfairDisplay(
    fontWeight: FontWeight.w600,
    fontSize: 24,
  );
  static TextStyle body = GoogleFonts.montserrat(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.45,
  );
  static TextStyle bodyBold = GoogleFonts.montserrat(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 1.45,
  );
}
