import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LanguageBadge extends StatelessWidget {
  final String language;
  final String? colorHex;

  const LanguageBadge({
    super.key,
    required this.language,
    this.colorHex,
  });

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(colorHex);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 11,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          language,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.languageDefault;
    try {
      final cleaned = hex.replaceFirst('#', '');
      if (cleaned.length == 6) {
        return Color(int.parse('FF$cleaned', radix: 16));
      }
    } catch (_) {}
    return AppColors.languageDefault;
  }
}
