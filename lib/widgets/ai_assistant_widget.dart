import 'package:flutter/material.dart';
import 'dart:async';

enum _ChatSender { ai, user }

class _ChatMessage {
  final String text;
  final _ChatSender sender;

  _ChatMessage({required this.text, required this.sender});
}

class AiAssistantWidget extends StatefulWidget {
  const AiAssistantWidget({super.key});

  @override
  State<AiAssistantWidget> createState() => _AiAssistantWidgetState();
}

class _AiAssistantWidgetState extends State<AiAssistantWidget> {
  final List<_ChatMessage> _chatHistory = [];
  List<String> _currentQuickReplies = [];
  final ScrollController _scrollController = ScrollController();
  bool _isAiTyping = false;

  // --- Data for the conversation ---
  final Map<String, String> _mainOptions = {
    "Plan & Schedule": "Great! I can help with your travel plans.",
    "Explore & Discover": "Let's find something exciting!",
    "Account & Settings": "Sure, let's get your settings sorted.",
  };

  final Map<String, String> _planningQuestions = {
    "How do I make a booking?":
        "You can book activities or hotels by tapping the 'Book Now' button on any item card or detail page. You can also start a general booking by tapping the shopping cart icon on the home screen.",
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

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeChat() {
    _chatHistory.add(_ChatMessage(
      text: "Hello! I’m your Japan Tour App Assistant 🌸\nHow can I help you today?",
      sender: _ChatSender.ai,
    ));
    _currentQuickReplies = _mainOptions.keys.toList();
  }

  void _handleQuickReply(String text) async {
    // Add user message
    _addMessage(_ChatMessage(text: text, sender: _ChatSender.user));

    // Show typing indicator and hide quick replies
    setState(() {
      _isAiTyping = true;
      _currentQuickReplies = [];
    });
    _scrollToBottom();

    // Simulate AI "thinking" time
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    String aiResponse;
    List<String> nextReplies;

    if (_mainOptions.containsKey(text)) {
      aiResponse = _mainOptions[text]!;
      if (text == "Plan & Schedule") nextReplies = _planningQuestions.keys.toList();
      else if (text == "Explore & Discover") nextReplies = _exploringQuestions.keys.toList();
      else nextReplies = _accountQuestions.keys.toList();
      nextReplies.add("<< Go Back");
    } else if (_planningQuestions.containsKey(text)) {
      aiResponse = _planningQuestions[text]!;
      nextReplies = ["<< Ask Another Question"];
    } else if (_exploringQuestions.containsKey(text)) {
      aiResponse = _exploringQuestions[text]!;
      nextReplies = ["<< Ask Another Question"];
    } else if (_accountQuestions.containsKey(text)) {
      aiResponse = _accountQuestions[text]!;
      nextReplies = ["<< Ask Another Question"];
    } else { // Go Back or Ask Another Question
      aiResponse = "Is there anything else I can help with?";
      nextReplies = _mainOptions.keys.toList();
    }

    // Hide typing indicator and show the AI response
    setState(() {
      _isAiTyping = false;
    });
    _addMessage(_ChatMessage(text: aiResponse, sender: _ChatSender.ai), nextReplies);
  }

  void _addMessage(_ChatMessage message, [List<String>? replies]) {
    setState(() {
      _chatHistory.add(message);
      if (replies != null) {
        _currentQuickReplies = replies;
      }
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  // --- UI building functions ---

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1A237E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _chatHistory.length + (_isAiTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _chatHistory.length) {
                  return _buildTypingIndicator();
                }
                final message = _chatHistory[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildQuickReplies(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _buildContactAdminButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage message) {
    final isAi = message.sender == _ChatSender.ai;
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isAi ? Colors.black.withOpacity(0.25) : Colors.deepPurpleAccent,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isAi ? const Radius.circular(4) : const Radius.circular(16),
            bottomRight: isAi ? const Radius.circular(16) : const Radius.circular(4),
          ),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: isAi ? Colors.white70 : Colors.white,
            fontSize: 15,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.25),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: const _TypingDots(),
      ),
    );
  }

  Widget _buildQuickReplies() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: _currentQuickReplies.map((option) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.deepPurple,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: () => _handleQuickReply(option),
            child: Text(option, style: const TextStyle(fontFamily: 'Poppins')),
          );
        }).toList(),
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

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  _TypingDotsState createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      )..forward();
    });

    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) => FadeTransition(opacity: _controllers[i], child: const Text('•', style: TextStyle(color: Colors.white54, fontSize: 24)))),
    );
  }
}
