import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// To enable the 'Call' button, add the url_launcher package to your pubspec.yaml
// dependencies:
//   url_launcher: ^6.1.14
import 'package:url_launcher/url_launcher.dart';
import '../copyright_footer.dart';

class HelpAndEmergencyPage extends StatefulWidget {
  const HelpAndEmergencyPage({super.key});

  @override
  State<HelpAndEmergencyPage> createState() => _HelpAndEmergencyPageState();
}

class _HelpAndEmergencyPageState extends State<HelpAndEmergencyPage> {
  bool _animateBanner = false;

  // Data for phrases, categorized for better organization
  final Map<String, List<Map<String, String>>> _phraseCategories = const {
    'General & Emergency': [
      {'en': 'I need help.', 'jp': '助けてください (Tasukete kudasai)'},
      {'en': 'Where is the hospital?', 'jp': '病院はどこですか (Byōin wa doko desu ka?)'},
      {'en': 'I am lost.', 'jp': '道に迷いました (Michi ni mayoimashita)'},
      {'en': 'I need a police officer.', 'jp': '警察官が必要です (Keisatsukan ga hitsuyō desu)'},
      {'en': 'Is there someone who speaks English?', 'jp': '英語を話せる人はいますか (Eigo o hanaseru hito wa imasu ka?)'},
    ],
    'Health & Allergies': [
      {'en': 'I have an allergy to [food].', 'jp': '[food]アレルギーがあります ([food] arerugī ga arimasu)'},
      {'en': 'Where is the nearest pharmacy?', 'jp': '最寄りの薬局はどこですか (Moyori no yakkyoku wa doko desu ka?)'},
      {'en': 'I feel sick.', 'jp': '気分が悪いです (Kibun ga warui desu)'},
    ],
    'Asking for Directions': [
      {'en': 'Excuse me, where is [place]?', 'jp': 'すみません、[place]はどこですか (Sumimasen, [place] wa doko desu ka?)'},
      {'en': 'How do I get to the station?', 'jp': '駅までどうやって行きますか (Eki made dōyatte ikimasu ka?)'},
    ],
  };

  // Data for basic first aid tips
  final List<Map<String, dynamic>> _firstAidTips = const [
    {
      'title': 'Minor Cuts',
      'icon': Icons.healing_outlined,
      'color': Colors.green,
      'steps': [
        'Wash your hands thoroughly.',
        'Stop the bleeding by applying gentle pressure with a clean cloth.',
        'Clean the wound with water. Avoid using soap on the wound itself.',
        'Apply an antiseptic ointment and cover with a sterile bandage.',
      ],
    },
    {
      'title': 'Minor Burns (First-degree)',
      'icon': Icons.whatshot_outlined,
      'color': Colors.orange,
      'steps': [
        'Immediately cool the burn under cool (not cold) running water for 10-20 minutes.',
        'Remove jewelry or tight items from the affected area before it swells.',
        'Cover loosely with a sterile gauze bandage.',
        'Do not use ice, butter, or ointments on the burn.',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    // jalankan animasi setelah build
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
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          AnimatedContainer(
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
            child: const Center(
              child: Text(
                "Help & Emergency",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildAnimatedItem(
                  delay: 100,
                  child: _buildSectionTitle(context, 'Emergency Contacts', Icons.contact_emergency_outlined),
                ),
                _buildAnimatedItem(
                  delay: 200,
                  child: _buildEmergencyContactCard(
                    context: context,
                    title: 'Police',
                    number: '110',
                    icon: Icons.local_police_outlined,
                    gradient: const LinearGradient(colors: [Color(0xFF2962FF), Color(0xFF64B5F6)]),
                  ),
                ),
                _buildAnimatedItem(
                  delay: 300,
                  child: _buildEmergencyContactCard(
                    context: context,
                    title: 'Ambulance / Fire',
                    number: '119',
                    icon: Icons.local_fire_department_outlined,
                    gradient: const LinearGradient(colors: [Color(0xFFD50000), Color(0xFFFF9E80)]),
                  ),
                ),
                _buildAnimatedItem(
                  delay: 400,
                  child: _buildEmergencyContactCard(
                    context: context,
                    title: 'Your Embassy',
                    number: '(+81) XX-XXXX-XXXX',
                    icon: Icons.flag_outlined,
                    gradient: const LinearGradient(colors: [Color(0xFF6200EA), Color(0xFFB388FF)]),
                    isPlaceholder: true,
                  ),
                ),
                const SizedBox(height: 24),
                _buildAnimatedItem(
                  delay: 500,
                  child: _buildSectionTitle(context, 'Useful Phrases', Icons.translate_outlined),
                ),
                ..._buildPhraseSection(),
                const SizedBox(height: 24),
                _buildAnimatedItem(
                  delay: 600,
                  child: _buildSectionTitle(context, 'Basic First Aid', Icons.medical_services_outlined),
                ),
                ..._buildFirstAidSection(),
                _buildAnimatedItem(
                  delay: 900,
                  child: const CopyrightFooter(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedItem({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + delay),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 25 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard({
    required BuildContext context,
    required String title,
    required String number,
    required IconData icon,
    required Gradient gradient,
    bool isPlaceholder = false,
  }) {
    Future<void> _makePhoneCall(String phoneNumber) async {
      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      if (!await launchUrl(launchUri)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch dialer for $phoneNumber')),
        );
      }
    }

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isPlaceholder ? null : () => _makePhoneCall(number),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(number, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),
                  if (!isPlaceholder)
                    const Icon(Icons.call, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPhraseSection() {
    int delay = 500;
    return _phraseCategories.entries.map((entry) {
      delay += 100;
      return _buildAnimatedItem(
        delay: delay,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            leading: const Icon(Icons.forum_outlined),
            title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600)),
            children: entry.value.map((phrase) {
              return _buildPhraseCard(phrase['en']!, phrase['jp']!);
            }).toList(),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPhraseCard(String english, String japanese) {
    return Builder(builder: (context) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
        title: Text(english),
        subtitle: Text(japanese, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500)),
        trailing: IconButton(
          icon: const Icon(Icons.copy_outlined, size: 20),
          tooltip: 'Copy Japanese phrase',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: japanese.split(' (')[0]));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Japanese phrase copied to clipboard!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
        ),
      );
    });
  }

  List<Widget> _buildFirstAidSection() {
    int delay = 700;
    return _firstAidTips.map((tip) {
      delay += 100;
      return _buildAnimatedItem(
        delay: delay,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            leading: Icon(tip['icon'], color: tip['color'] as Color),
            title: Text(tip['title'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
            children: (tip['steps'] as List<String>).map<Widget>((step) {
              return ListTile(
                contentPadding: const EdgeInsets.fromLTRB(32, 0, 16, 8),
                leading: const Icon(Icons.arrow_right, color: Colors.grey),
                title: Text(step, style: const TextStyle(fontSize: 14)),
              );
            }).toList(),
          ),
        ),
      );
    }).toList();
  }
}