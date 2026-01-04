import 'package:flutter/foundation.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? category;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.category,
  });
}

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => List.from(_messages);

  void addMessage({
    required String text,
    required bool isUser,
    String? category,
  }) {
    _messages.insert(
      0,
      ChatMessage(
        text: text,
        isUser: isUser,
        timestamp: DateTime.now(),
        category: category,
      ),
    );
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
