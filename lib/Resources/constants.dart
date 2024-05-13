import 'package:flutter/material.dart';
import 'package:minervaschool/Resources/app_font.dart';

import 'app_colors.dart';

/// TEXTSTYLES
TextStyle ts22Bold = const TextStyle(
    fontWeight: FontWeight.bold, fontSize: 22, fontFamily: AppFonts.jostBold);
TextStyle ts20Bold = const TextStyle(
    fontWeight: FontWeight.bold, fontSize: 20, fontFamily: AppFonts.jostBold);
TextStyle ts18Bold = const TextStyle(
    fontWeight: FontWeight.bold, fontSize: 18, fontFamily: AppFonts.jostBold);
TextStyle ts16Bold = const TextStyle(
    fontWeight: FontWeight.bold, fontSize: 16, fontFamily: AppFonts.jostBold);
TextStyle ts14Bold = const TextStyle(
    fontWeight: FontWeight.bold, fontSize: 14, fontFamily: AppFonts.jostBold);
TextStyle ts12Bold = const TextStyle(
    fontWeight: FontWeight.bold, fontSize: 12, fontFamily: AppFonts.jostBold);

TextStyle ts25Normal =
    const TextStyle(fontSize: 25, fontFamily: AppFonts.jostRegular);
TextStyle ts22Normal =
    const TextStyle(fontSize: 22, fontFamily: AppFonts.jostRegular);
TextStyle ts20Normal =
    const TextStyle(fontSize: 20, fontFamily: AppFonts.jostRegular);
TextStyle ts18Normal =
    const TextStyle(fontSize: 18, fontFamily: AppFonts.jostRegular);
TextStyle ts16Normal =
    const TextStyle(fontSize: 16, fontFamily: AppFonts.jostRegular);
TextStyle ts14Normal =
    const TextStyle(fontSize: 14, fontFamily: AppFonts.jostRegular);
TextStyle ts12Normal =
    const TextStyle(fontSize: 12, fontFamily: AppFonts.jostRegular);
TextStyle ts15Normal =
    const TextStyle(fontSize: 15, fontFamily: AppFonts.jostRegular);
TextStyle ts13Normal =
    const TextStyle(fontSize: 13, fontFamily: AppFonts.jostRegular);
TextStyle ts11Normal =
    const TextStyle(fontSize: 11, fontFamily: AppFonts.jostRegular);
TextStyle ts10Normal =
    const TextStyle(fontSize: 10, fontFamily: AppFonts.jostRegular);

InputDecoration customRoundedTextFieldDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
    hintText: "Hint",
    hintStyle: ts14Normal,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey, width: 2),
        borderRadius: BorderRadius.circular(8.0)),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey, width: 2),
        borderRadius: BorderRadius.circular(8.0)));
