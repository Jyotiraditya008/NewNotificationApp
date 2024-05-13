import 'package:flutter/material.dart';

import '../Resources/app_colors.dart';

class InkwellWidget extends StatelessWidget {
  final Widget child;
  final Function() onTap;
  const InkwellWidget({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: AppColors.transparent,
      splashColor: AppColors.transparent,
      onTap: onTap,
      child: child,
    );
  }
}
