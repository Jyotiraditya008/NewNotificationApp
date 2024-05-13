import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minervaschool/Resources/constants.dart';

import '../Resources/app_colors.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final double? width;
  final double? height;
  final InputDecoration? inputDecoration;
  final int? maxLength;
  final TextInputType? textInputType;
  final TextStyle textStyle;
  final void Function(String)? onChanged;
  final TextAlign? textAlign;
  final String? hintText;
  final String? labelText;
  const CustomTextFormField(
      {Key? key,
      this.controller,
      this.width,
      this.height,
      this.inputDecoration,
      this.maxLength,
      this.textInputType,
      required this.textStyle,
      this.onChanged,
      this.textAlign,
      this.hintText,
      this.labelText})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        decoration: widget.inputDecoration ??
            InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: AppColors.grey200,
                hintText: widget.hintText,
                filled: true,
                hintStyle: ts13Normal,
                labelText: widget.labelText,
                labelStyle: ts13Normal.copyWith(color: AppColors.black),
                focusColor: AppColors.black,
                counterText: ""),
        textAlign:
            widget.textAlign == null ? TextAlign.center : widget.textAlign!,
        maxLength: widget.maxLength,
        keyboardType: widget.textInputType ?? TextInputType.text,
        style: widget.textStyle,
        onChanged: widget.onChanged ?? (value) {},
      ),
    );
  }
}
