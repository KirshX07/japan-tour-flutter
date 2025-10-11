import 'package:flutter/material.dart';

/// ⭐ Widget untuk menampilkan rating bintang
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: size));
    }
    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: size));
    }
    for (int i = (fullStars + (hasHalfStar ? 1 : 0)); i < 5; i++) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: size));
    }
    return Row(children: stars);
  }
}

/// ✨ Widget animasi list item (fade + slide)
/// Bisa digunakan dengan `delay` atau `index`.
class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int? delay; // dalam milidetik (opsional)
  final int? index; // opsional juga

  const AnimatedListItem({
    super.key,
    required this.child,
    this.delay,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung delay akhir (kalau delay null, pakai index * 100)
    final int effectiveDelay = delay ?? (index != null ? index! * 100 : 0);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + effectiveDelay),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 30),
            child: child,
          ),
        );
      },
    );
  }
}

/// ℹ️ Widget baris informasi dengan ikon dan teks
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final double iconSize;
  final double textSize;

  const InfoRow({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
    this.iconSize = 18,
    this.textSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: iconSize, color: iconColor ?? Colors.white70),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: textSize,
              color: textColor ?? Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
