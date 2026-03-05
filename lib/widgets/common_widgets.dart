import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double radius;
  const AppCard({super.key, required this.child, this.padding, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [BoxShadow(color: Color(0x143D2B1F), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }
}

class CurlTypeBadge extends StatelessWidget {
  final String type;
  final bool large;
  const CurlTypeBadge(this.type, {super.key, this.large = false});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.curlTypeColor(type);
    final bg = AppColors.curlTypeBg(type);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: large ? 14 : 8, vertical: large ? 5 : 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(type,
        style: GoogleFonts.notoSansKr(
          fontSize: large ? 13 : 11, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class TagChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const TagChip(this.label, {super.key, this.active = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: active ? AppColors.peach : AppColors.peachLight,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text('#$label',
          style: GoogleFonts.notoSansKr(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: active ? Colors.white : AppColors.peachDark)),
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  const StarRating(this.rating, {super.key, this.size = 14});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.star_rounded, size: size, color: AppColors.star),
      const SizedBox(width: 2),
      Text(rating.toStringAsFixed(1),
        style: GoogleFonts.notoSansKr(fontSize: size - 1, fontWeight: FontWeight.w600, color: AppColors.brown)),
    ]);
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const SectionHeader(this.title, {super.key, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: GoogleFonts.notoSansKr(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.brown)),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text('전체보기',
              style: GoogleFonts.notoSansKr(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.teal)),
          ),
      ],
    );
  }
}

class AppBottomSheet extends StatelessWidget {
  final Widget child;
  const AppBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4, decoration: BoxDecoration(
          color: AppColors.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 8),
        child,
      ]),
    );
  }
}

Widget buildPrimaryButton(String label, VoidCallback? onPressed) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    ),
  );
}
