import 'package:flutter/material.dart';

// Enum to manage the conversation state
enum _ConversationState { initial, planning, exploring, account, showingAnswer }

class AiAssistantWidget extends StatefulWidget {
  const AiAssistantWidget({super.key});

  @override
  State<AiAssistantWidget> createState() => _AiAssistantWidgetState();
}

class _AiAssistantWidgetState extends State<AiAssistantWidget> {
  _ConversationState _currentState = _ConversationState.initial;
  String _currentMessage = "Hello! I’m your Japan Tour App Assistant 🌸\nHow can I help you today?";
  String? _answer;

  // --- Data for the conversation ---
  final Map<String, String> _mainOptions = {
    "Plan & Schedule": "Great! I can help with your travel plans.",
    "Explore & Discover": "Let's find something exciting!",
    "Account & Settings": "Sure, let's get your settings sorted.",
  };

  final Map<String, String> _planningQuestions = {
    "How can I see my travel plan?": "Your travel plan is available in the ‘Schedule’ section.",
    "How do I check transportation routes?": "You can check train and bus routes in the ‘Transport’ menu.",
    "How can I check event schedules?": "Tap ‘Events’ to see upcoming festivals and local activities.",
  };

  final Map<String, String> _exploringQuestions = {
    "How can I use the offline map?": "You can use the offline map by downloading the area in advance.",
    "Where can I view my saved favorites?": "Your favorite places are saved in the ‘Favorites’ tab.",
    "How can I get recommendations for places to visit?": "Check the 'Recommendations' section for curated lists of must-see spots.",
  };

  final Map<String, String> _accountQuestions = {
    "How do I change the profile picture?": "Change your profile picture in the Profile menu.",
    "How do I log out?": "You can log out from the Profile menu under 'Device Info'.",
    "How can I delete my account?": "To delete your account, please contact admin kiranashofa0103@gmail.com.",  
  };

  // --- State management functions ---

  void _handleMainOption(String option) {
    setState(() {
      _currentMessage = _mainOptions[option]!;
      if (option == "Plan & Schedule") {
        _currentState = _ConversationState.planning;
      } else if (option == "Explore & Discover") {
        _currentState = _ConversationState.exploring;
      } else {
        _currentState = _ConversationState.account;
      }
    });
  }

  void _handleQuestion(String question, String answer) {
    setState(() {
      _currentState = _ConversationState.showingAnswer;
      _answer = answer;
      _currentMessage = question;
    });
  }

  void _goBack() {
    setState(() {
      _currentState = _ConversationState.initial;
      _currentMessage = "Is there anything else I can help with?";
    });
  }

  void _reset() {
    setState(() {
      _currentState = _ConversationState.initial;
      _currentMessage = "Hello! I’m your Japan Tour App Assistant 🌸\nHow can I help you today?";
      _answer = null;
    });
  }

  // --- UI building functions ---

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildAssistantMessage(),
          const SizedBox(height: 20),
          ..._buildContent(),
          const SizedBox(height: 20),
          _buildContactAdminButton(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildAssistantMessage() {
    return Text(
      _currentMessage,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    );
  }

  List<Widget> _buildContent() {
    switch (_currentState) {
      case _ConversationState.initial:
        return [_buildQuickReplies(_mainOptions.keys.toList(), _handleMainOption)];
      case _ConversationState.planning:
        return [_buildQuickReplies(_planningQuestions.keys.toList(), (q) => _handleQuestion(q, _planningQuestions[q]!)), _buildBackButton()];
      case _ConversationState.exploring:
        return [_buildQuickReplies(_exploringQuestions.keys.toList(), (q) => _handleQuestion(q, _exploringQuestions[q]!)), _buildBackButton()];
      case _ConversationState.account:
        return [_buildQuickReplies(_accountQuestions.keys.toList(), (q) => _handleQuestion(q, _accountQuestions[q]!)), _buildBackButton()];
      case _ConversationState.showingAnswer:
        return [_buildAnswerBox(), _buildBackButton(isBackToStart: true)];
    }
  }

  Widget _buildQuickReplies(List<String> options, Function(String) onPressed) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: options.map((option) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.deepPurple, backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          onPressed: () => onPressed(option),
          child: Text(option, style: const TextStyle(fontFamily: 'Poppins')),
        );
      }).toList(),
    );
  }

  Widget _buildAnswerBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _answer ?? "",
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 15, fontFamily: 'Poppins'),
      ),
    );
  }

  Widget _buildBackButton({bool isBackToStart = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextButton(
        onPressed: isBackToStart ? _reset : _goBack,
        child: Text(
          isBackToStart ? "<< Ask Another Question" : "<< Go Back",
          style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
        ),
      ),
    );
  }

  Widget _buildContactAdminButton() {
    return OutlinedButton.icon(
      icon: const Icon(Icons.support_agent, size: 18),
      label: const Text("Contact Admin"),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF1A237E),
            title: const Text("Contact Information", style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            content: const SelectableText(
              "Kirana Shofa Dzakiyyah\nkiranashofa0103@gmail.com",
              style: TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white.withOpacity(0.8),
        side: BorderSide(color: Colors.white.withOpacity(0.5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
