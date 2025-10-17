import 'package:flutter/material.dart';
import '../login_page.dart';
import '../copyright_footer.dart';
import 'package:flutter_app/widgets/page_header.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../widgets/page_transitions.dart';
import '../widgets/shared_widgets.dart';
import 'edit_profile_page.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // ✅ untuk cek platform
import 'dart:html' as html; // ✅ hanya aktif di Flutter Web

class ProfilePage extends StatelessWidget {
  final String username;
  const ProfilePage({super.key, required this.username});

  String get _displayName {
    if (username == "Guest") {
      return "Guest User";
    }
    final namePart = username.split('@')[0];
    return namePart
        .split(RegExp(r'[._]'))
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const PageHeader(title: "Profile", showBack: false),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: <Widget>[
              AnimatedListItem(delay: 100, child: _buildProfileHeader(context)),
              const SizedBox(height: 20),
              AnimatedListItem(delay: 200, child: _buildProfileMenu(context)),
              const SizedBox(height: 20),
              const AnimatedListItem(delay: 300, child: CopyrightFooter()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            image: const DecorationImage(
              image: AssetImage('assets/banner.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              FadePageRoute(child: EditProfilePage(username: username)),
            ),
            child: Hero(
              tag: 'profile_picture',
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3), // ✅ perbaikan di sini
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage('assets/Cerydra.jpg'),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  username,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 60),
        _buildMenuCard(
          icon: Icons.edit_outlined,
          text: 'Edit Profile',
          onTap: () {
            Navigator.push(
              context,
              FadePageRoute(child: EditProfilePage(username: username)),
            );
          },
        ),
        _buildMenuCard(
          icon: Icons.settings_outlined,
          text: 'Settings',
          onTap: () {},
        ),
        _buildMenuCard(
          icon: Icons.info_outline,
          text: 'Show Popup',
          onTap: () {
            GFToast.showToast(
              'This is a popup from GetWidget!',
              context,
              toastPosition: GFToastPosition.BOTTOM,
              backgroundColor: Colors.deepPurpleAccent,
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              trailing: const Icon(Icons.notifications, color: Colors.white),
              toastDuration: 3,
            );
          },
        ),
        _buildMenuCard(
          icon: Icons.notifications_outlined,
          text: 'Notifications',
          onTap: () {},
        ),
        const SizedBox(height: 10),
        _buildMenuCard(
          icon: Icons.info_outline,
          text: 'Device Info',
          onTap: () => _showDeviceInfoDialog(context),
        ),
        const SizedBox(height: 10),
        _buildMenuCard(
          icon: Icons.logout,
          text: 'Logout',
          color: Colors.red,
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return AnimatedListItem(
      child: Card(
        color: const Color(0xFF4A148C).withOpacity(0.3),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          leading: Icon(icon, color: color ?? Colors.white70),
          title: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color ?? Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          trailing: Icon(Icons.chevron_right, color: color ?? Colors.white54),
          onTap: onTap,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C1D57),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeviceInfoDialog(BuildContext context) async {
    String infoText = '';

    if (kIsWeb) {
      // ✅ Kalau di web (GitHub Pages)
      final userAgent = html.window.navigator.userAgent;
      final platform = html.window.navigator.platform;
      infoText = 'Platform: $platform\nUser Agent:\n$userAgent';
    } else {
      // ✅ Kalau di Android/iOS pakai device_info_plus
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      infoText =
          'Model: ${androidInfo.model}\nBrand: ${androidInfo.brand}\nAndroid Version: ${androidInfo.version.release}\nSDK: ${androidInfo.version.sdkInt}';
    }

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C1D57),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'Device Information',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          infoText,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }
}
