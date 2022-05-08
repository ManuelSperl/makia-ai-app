import 'package:flutter/material.dart';

/*
    Renders the Icon-Card Widget
 */
class IconCard extends StatelessWidget {
  final double height;
  final double width;
  final Color cardColor;
  final double borderRadius;
  final IconData icon;
  final Color iconColor;

  IconCard({
    this.height,
    this.width,
    @required this.cardColor,
    @required this.borderRadius,
    @required this.icon,
    @required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(borderRadius),
        ),
      ),
      child: Icon(
        icon,
        color: iconColor,
      ),
    );
  }
}
