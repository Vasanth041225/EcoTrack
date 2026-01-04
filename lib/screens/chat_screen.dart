import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addWelcomeMessage();
    });
  }

  void _addWelcomeMessage() {
    Provider.of<ChatProvider>(context, listen: false).addMessage(
      text: '''🌿 **Welcome to EcoTrack Assistant!**

I'm here to help you live more sustainably. Ask me about:

♻️ Recycling guidelines
🌱 Composting at home
⚡ Saving energy
💧 Conserving water
🚲 Green transportation
🛍️ Eco-friendly shopping
🌽 Sustainable eating
💡 General green tips

If you're having trouble reporting an issue or want to track your environmental impact, just let me know!

What can I help you with today?''',
      isUser: false,
      category: 'greeting',
    );
  }

  void _sendMessage() async {
    final text = _textController.text.trim();
    if (text.isEmpty || _isTyping) return;

    // Add user message
    Provider.of<ChatProvider>(context, listen: false).addMessage(
      text: text,
      isUser: true,
    );
    _textController.clear();
    _scrollToBottom();

    // Show typing indicator
    setState(() => _isTyping = true);

    // Get bot response
    final response = await ChatService.analyzeMessage(text);
    final category = ChatService.getMessageCategory(text);

    // Simulate typing delay
    await Future.delayed(Duration(milliseconds: 500 + (text.length ~/ 10)));

    setState(() => _isTyping = false);

    // ignore: use_build_context_synchronously
    Provider.of<ChatProvider>(context, listen: false).addMessage(
      text: response,
      isUser: false,
      category: category,
    );

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showQuickTopics() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quick Topics',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _TopicChip('What can I recycle?'),
                  _TopicChip('How to compost?'),
                  _TopicChip('Save energy tips'),
                  _TopicChip('Reduce water usage'),
                  _TopicChip('Eco-friendly shopping'),
                  _TopicChip('Sustainable diet'),
                  _TopicChip('Electric cars'),
                  _TopicChip('Solar panels'),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.eco, color: Colors.white),
            SizedBox(width: 10),
            Text('Green Assistant'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false).clearChat();
            },
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick action buttons
          Container(
            height: 60,
            color: Colors.green[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _QuickActionButton(
                  icon: Icons.recycling,
                  label: 'Recycling',
                  onTap: () => _textController.text = 'What can I recycle?',
                ),
                _QuickActionButton(
                  icon: Icons.energy_savings_leaf,
                  label: 'Energy',
                  onTap: () => _textController.text = 'How to save energy?',
                ),
                _QuickActionButton(
                  icon: Icons.water_drop,
                  label: 'Water',
                  onTap: () => _textController.text = 'Water saving tips',
                ),
                _QuickActionButton(
                  icon: Icons.local_florist,
                  label: 'More',
                  onTap: _showQuickTopics,
                ),
              ],
            ),
          ),

          // Chat messages
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                final messages = provider.messages;
                return ListView.builder(
                  controller: _scrollController,
                  reverse: true,
                  itemCount: messages.length + (_isTyping ? 1 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == 0) {
                      return _TypingIndicator();
                    }
                    final messageIndex = _isTyping ? index - 1 : index;
                    final message = messages[messageIndex];
                    return _ChatBubble(message: message);
                  },
                );
              },
            ),
          ),

          // Input area
          _MessageInput(
            controller: _textController,
            onSend: _sendMessage,
            isTyping: _isTyping,
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 8,
        left: message.isUser ? 60 : 15,
        right: message.isUser ? 15 : 60,
        top: 8,
      ),
      child: Column(
        crossAxisAlignment:
            message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!message.isUser && message.category != null)
            Container(
              margin: const EdgeInsets.only(left: 8, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: _getCategoryColor(message.category!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.category!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: message.isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!message.isUser)
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.green,
                  child: Icon(Icons.eco, size: 18, color: Colors.white),
                ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(
                    left: message.isUser ? 0 : 8,
                    right: message.isUser ? 8 : 0,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        message.isUser ? Colors.green[100] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: message.isUser
                          ? Colors.green[200]!
                          : Colors.grey[300]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[800],
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (message.isUser)
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.person, size: 18, color: Colors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'recycling':
        return Colors.blue;
      case 'composting':
        return Colors.brown;
      case 'energy':
        return Colors.orange;
      case 'water':
        return Colors.lightBlue;
      case 'transport':
        return Colors.green;
      case 'shopping':
        return Colors.purple;
      case 'food':
        return Colors.red;
      case 'greeting':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.green,
            child: Icon(Icons.eco, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isTyping;

  const _MessageInput({
    required this.controller,
    required this.onSend,
    required this.isTyping,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Ask about green living...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              maxLines: 3,
              minLines: 1,
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTyping ? Colors.grey : Colors.green,
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: isTyping ? null : onSend,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  final String text;

  const _TopicChip(this.text);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        Navigator.pop(context);
        // You would need to pass a callback to update the text field
      },
      backgroundColor: Colors.green[50],
      labelStyle: const TextStyle(color: Colors.green),
    );
  }
}
