import 'package:flutter/material.dart';
import 'package:milk_admin_panel/utils/colors.dart';

class FloatingActionButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const FloatingActionButtonWidget({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: indigo700,
      onPressed: onPressed,
      child: Icon(icon,color: Colors.white),
    );
  }
}
