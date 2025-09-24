import 'package:flutter/material.dart';

class AnimatedPageHeader extends StatefulWidget {
  final String title;

  const AnimatedPageHeader({
    super.key,
    required this.title,
  });

  @override
  State<AnimatedPageHeader> createState() => _AnimatedPageHeaderState();
}

class _AnimatedPageHeaderState extends State<AnimatedPageHeader> {
  bool _animateBanner = false;

  @override
  void initState() {
    super.initState();
    // Run animation after the first frame
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _animateBanner = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutCubic,
      height: _animateBanner ? 110 : 0,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}