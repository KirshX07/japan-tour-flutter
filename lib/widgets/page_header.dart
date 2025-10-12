import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  const PageHeader({super.key, required this.title, this.showBack = true});

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBack,
      iconTheme: const IconThemeData(
        color: Colors.white, // Memastikan tombol kembali berwarna putih
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF2E1B8C),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
    );
  }
}
