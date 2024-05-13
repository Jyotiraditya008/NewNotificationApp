import 'package:flutter/material.dart';

import 'inkwell_widget.dart';

class CustomRoundedButton extends StatefulWidget {
  final double? width;
  final double? height;
  final double? elevation;
  final BoxDecoration? boxDecoration;
  final Color? color;
  final Widget child;
  final Function() onPress;
  const CustomRoundedButton(
      {Key? key,
      this.height,
      this.width,
      this.elevation,
      this.boxDecoration,
      this.color,
      required this.onPress,
      required this.child,
      required TextEditingController controller})
      : super(key: key);

  @override
  State<CustomRoundedButton> createState() => _CustomRoundedButtonState();
}

class _CustomRoundedButtonState extends State<CustomRoundedButton> {
  @override
  Widget build(BuildContext context) {
    return InkwellWidget(
      onTap: widget.onPress,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: widget.boxDecoration,
        color: widget.color,
        alignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
