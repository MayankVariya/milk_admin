import 'package:flutter/material.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:provider/provider.dart';

import '../dark_theme_provider.dart';

class BtnIcon extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? iconColor;

  const BtnIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        splashRadius: 10,
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor));
  }
}

class BtnCancel extends StatelessWidget {
  const BtnCancel({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<DarkThemeProvider>(context);
    return BtnText(
        text: btnCancel, onPressed: () => Navigator.of(context).pop());
  }
}

class BtnText extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const BtnText({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: themeChange.darkTheme ? white : indigo700),
      ),
    );
  }
}

class BtnMaterial extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final double? hPadding;
  final double? vPadding;
  const BtnMaterial(
      {super.key,
      required this.onPressed,
      required this.child,
      this.color,
      this.hPadding,
      this.vPadding});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(
          horizontal: hPadding ?? 25, vertical: vPadding ?? 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: onPressed,
      color: color ?? indigo700,
      child: child,
    );
  }
}
