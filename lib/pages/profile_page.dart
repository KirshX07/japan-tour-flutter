import 'package:flutter/material.dart';
import '../login_page.dart';
import '../copyright_footer.dart';
import 'package:flutter_app/pages/animated_page_header.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../widgets/shared_widgets.dart';
import 'edit_profile_page.dart';

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
        const AnimatedPageHeader(title: "Profile"),
        Expanded(
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: <Widget>[
              AnimatedListItem(delay: 100, child: _buildProfileHeader(context)),
              const SizedBox(height: 20),
              AnimatedListItem(delay: 200, child: _buildProfileMenu(context)),
              const SizedBox(height: 20),
              AnimatedListItem(delay: 300, child: const CopyrightFooter()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF4A148C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A148C).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(username: username),
              ),
            ),
            child: const Hero(
              tag: 'profile_picture',
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/Cerydra.jpg'),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _displayName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            username,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildMenuCard(
          icon: Icons.edit_outlined,
          text: 'Edit Profile',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(username: username),
              ),
            );
          },
        ),
        _buildMenuCard(
          icon: Icons.settings_outlined,
          text: 'Settings',
          onTap: () {},
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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Logout', style: TextStyle(color: Colors.white)),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white70)),
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
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2C1D57),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Device Information',
            style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Model', androidInfo.model),
              _buildInfoRow('Brand', androidInfo.brand),
              _buildInfoRow('Android Version', androidInfo.version.release),
              _buildInfoRow('SDK', '${androidInfo.version.sdkInt}'),
            ]
                .map((widget) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: widget))
                .toList(),
          ),
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

  Widget _buildInfoRow(String label, String value) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(color: Colors.white70, fontSize: 14),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
