import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon({
    super.key,
    required this.onTap,
    required this.icon,
    this.color,
  });

  final VoidCallback onTap;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color ?? const Color(0XFF191919),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: const Color(0XFFEEEEEE),
          size: 20.sp,
        ),
        onPressed: onTap,
        splashRadius: 20,
      ),
    );
  }
}
