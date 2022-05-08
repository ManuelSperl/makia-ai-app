import 'package:flutter/material.dart';

import 'package:makia_ai/constant_values.dart';

/*
    Renders the Icon Widget
 */
class IconWidget extends StatelessWidget {
  final IconData icon;
  final Color color;

  IconWidget({
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding / 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
