import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final Color? color;
  final TextStyle? textStyle;
  final void Function()? onPressed;
  final Size? minimumSize;
  final double width;
  final double height;
  const AppTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.textStyle,
    this.minimumSize,
    this.width = 0,
    this.height = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: color ?? Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(width, height),
          padding: const EdgeInsets.all(14.6),
        ),
        child: Text(
          text,
        ),
      ),
    );
  }
}
