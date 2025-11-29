

import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/ui_helpers.dart';
import '../../services/ai_tutor_service.dart';

class AITutorScreen extends StatefulWidget {
  const AITutorScreen({Key? key}) : super(key: key);

  @override
  State<AITutorScreen> createState() => _AITutorScreenState();
}

class _AITutorScreenState extends State<AITutorScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;

  
  final List<Map<String, String>> _messages = [
    {
      "from": "ai",
      "text":
          "Hi! I'm your CodeLingo AI Tutor.\nAsk any coding doubt — I'll start with hints and explanations first!",
    },
  ];

  

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String? _getLastUserQuestion() {
    for (int i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i]['from'] == 'user') {
        return _messages[i]['text'];
      }
    }
    return null;
  }

  void _addMessage(String from, String text) {
    setState(() {
      _messages.add({"from": from, "text": text});
    });
    _scrollToBottom();
  }

  

  Future<void> _sendMessage() async {
    final raw = _messageController.text.trim();
    if (raw.isEmpty || _isLoading) return;

    _messageController.clear();
    _addMessage("user", raw);

    setState(() => _isLoading = true);

    try {
      
      final reply = await AITutorService.ask(
        question: raw,
        language: "python",
        level: "beginner",
      );

      _addMessage("ai", reply);
    } catch (e) {
      _addMessage("ai", "Sorry, I couldn't reach the tutor API.\n$e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  

  Future<void> _askHint() async {
    final lastQuestion = _getLastUserQuestion();
    if (lastQuestion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ask a question first, then request a hint."),
        ),
      );
      return;
    }

    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final hintQuestion =
          "Give me just a hint for this problem (no full solution yet):\n$lastQuestion";

      final reply = await AITutorService.ask(
        question: hintQuestion,
        language: "python",
        level: "beginner",
      );

      _addMessage("ai", reply);
    } catch (e) {
      _addMessage("ai", "Couldn't fetch a hint right now.\n$e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  

  Future<void> _revealSolution() async {
    final lastQuestion = _getLastUserQuestion();
    if (lastQuestion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ask a question first before requesting a solution."),
        ),
      );
      return;
    }

    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      final solution = await AITutorService.revealSolution(
        question: lastQuestion,
        language: "python",
      );

      _addMessage("ai", solution);
    } catch (e) {
      _addMessage("ai", "Couldn't fetch the full solution right now.\n$e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "AI Tutor",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["from"] == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primaryGreen.withOpacity(0.15)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isUser
                            ? AppColors.primaryGreen
                            : AppColors.lockedGray,
                        width: 1.4,
                      ),
                    ),
                    child: Text(
                      msg["text"] ?? "",
                      style: TextStyle(
                        fontSize: 15,
                        color: isUser
                            ? AppColors.primaryGreen
                            : AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 8),
                  Text(
                    "AI is thinking...",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _askHint,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentBlue,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UIHelpers.radiusM),
                      ),
                    ),
                    child: const Text(
                      "Hint Please",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _revealSolution,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.incorrectRed,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UIHelpers.radiusM),
                      ),
                    ),
                    child: const Text(
                      "I can't do it",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),

          
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Image/file upload coming later."),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.image_outlined,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("File upload coming later."),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.attach_file,
                      color: AppColors.textSecondary,
                    ),
                  ),

                
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: "Ask your coding doubt...",
                        hintStyle: TextStyle(color: AppColors.textLight),
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  
                  IconButton(
                    onPressed: _isLoading ? null : _sendMessage,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
