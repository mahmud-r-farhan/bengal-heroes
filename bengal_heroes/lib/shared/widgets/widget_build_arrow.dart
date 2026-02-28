import 'package:flutter/material.dart';

class BuildArrow extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final bool isLeft;

  final ThemeData theme;
  final double top;
  final double size;
  final double iconSize;
  final double horizontalPadding;

  const BuildArrow({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.isLeft,
    required this.theme,
    this.top = 8,
    this.size = 40,
    this.iconSize = 18,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: isLeft ? horizontalPadding : null,
      right: isLeft ? null : horizontalPadding,
      top: top,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 8,
            ),
          ],
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: iconSize),
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}