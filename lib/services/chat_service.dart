import 'dart:math';
import '../utils/knowledge_base.dart';

class ChatService {
  // Analyze message and generate response
  static Future<String> analyzeMessage(String message) async {
    // Clean the message
    final cleanedMessage = message.trim().toLowerCase();

    // Check if it's a greeting
    if (_isGreeting(cleanedMessage)) {
      return GreenKnowledgeBase.responses['greeting']![0];
    }

    // Check message complexity
    final wordCount = cleanedMessage.split(' ').length;
    final hasKeywords = _extractKeywords(cleanedMessage).isNotEmpty;

    // If message is long or has many keywords, analyze deeply
    if (wordCount > 15 || hasKeywords) {
      return _analyzeComplexMessage(message);
    }

    // Simple message - use basic response
    return _getBasicResponse(message);
  }

  // Extract important keywords from message
  static List<String> _extractKeywords(String message) {
    const commonWords = {
      'how',
      'where',
      'what',
      'when',
      'why',
      'the',
      'a',
      'an',
      'and',
      'or',
      'but',
      'in',
      'on',
      'at',
      'to',
      'for',
      'of',
      'with',
      'by',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'have',
      'has',
      'had',
      'do',
      'does',
      'did',
      'will',
      'would',
      'shall',
      'should',
      'can',
      'could',
      'may',
      'might',
      'must',
      'i',
      'you',
      'he',
      'she',
      'it',
      'we',
      'they',
      'me',
      'him',
      'her',
      'us',
      'them',
      'my',
      'your',
      'his',
      'our',
      'their',
      'mine',
      'yours',
      'hers',
      'ours',
      'theirs',
    };

    final words = message.split(RegExp(r'\s+'));
    final keywords = words
        .where((word) => word.length > 2)
        .where((word) => !commonWords.contains(word))
        .map((word) => word.replaceAll(RegExp(r'[^\w\s]'), ''))
        .where((word) => word.isNotEmpty)
        .toList();

    return keywords;
  }

  // Check if message is a greeting
  static bool _isGreeting(String message) {
    final greetings = {
      'hello',
      'hi',
      'hey',
      'good morning',
      'good afternoon',
      'good evening',
      'howdy',
      'greetings',
      'what\'s up',
      'sup',
    };

    return greetings.any(message.contains);
  }

  // Analyze complex/lengthy messages
  static String _analyzeComplexMessage(String originalMessage) {
    final message = originalMessage.toLowerCase();
    final keywords = _extractKeywords(message);

    // Try to categorize using knowledge base
    final categorizedResponse = GreenKnowledgeBase.categorizeAndRespond(
      message,
    );

    // Check if we should use AI (if no clear category match)
    final shouldUseAI = _shouldUseAI(keywords, categorizedResponse);

    if (shouldUseAI) {
      // This is where you would call an AI API
      // For now, return an enhanced response
      return _enhanceResponse(categorizedResponse, keywords);
    }

    return categorizedResponse;
  }

  // Determine if we should use AI API
  static bool _shouldUseAI(List<String> keywords, String currentResponse) {
    // Use AI if:
    // 1. No keywords detected
    // 2. Response is too generic
    // 3. Message is very long (>50 words)

    if (keywords.isEmpty) return true;

    // Check if response is generic (contains common phrases)
    final genericPhrases = [
      'I\'m not sure',
      'general advice',
      'feel free to ask',
      'green lifestyle basics',
    ];

    final isGeneric = genericPhrases.any(currentResponse.contains);

    return isGeneric;
  }

  // Enhance response with AI-like features
  static String _enhanceResponse(String baseResponse, List<String> keywords) {
    if (keywords.isEmpty) {
      return baseResponse;
    }

    final enhanced = '''
$baseResponse

🔍 **Based on your keywords:** ${keywords.take(3).join(', ')}

💡 **Personalized Tip:** Try focusing on ${keywords.isNotEmpty ? keywords.first : 'one area'} first. Master it before moving to the next green habit!

❓ **Need more specific advice about ${keywords.isNotEmpty ? keywords.first : 'this topic'}?**''';

    return enhanced;
  }

  // Get basic response for simple messages
  static String _getBasicResponse(String message) {
    final lowerMessage = message.toLowerCase();

    // Quick pattern matching for common questions
    if (lowerMessage.contains('thanks') || lowerMessage.contains('thank you')) {
      return '''You're welcome! 😊 
Remember: Every green choice makes a difference!''';
    }

    if (lowerMessage.contains('bye') || lowerMessage.contains('goodbye')) {
      return '''Goodbye! 🌿
Keep up the great work for our planet!
Come back anytime for more green tips.''';
    }

    if (lowerMessage.contains('help')) {
      return '''I can help you with:
• How to use EcoTrack features 🛠️
• Recycling guidelines ♻️
• Composting tips 🌱
• Energy saving ⚡
• Water conservation 💧
• And much more!

Just ask me about any green topic!''';
    }

    // Default response
    return GreenKnowledgeBase.categorizeAndRespond(message);
  }

  // Get message category for UI display
  static String getMessageCategory(String message) {
    final lowerMessage = message.toLowerCase();

    for (final category in GreenKnowledgeBase.categories.keys) {
      for (final keyword in GreenKnowledgeBase.categories[category]!) {
        if (lowerMessage.contains(keyword)) {
          return category;
        }
      }
    }

    return 'general';
  }
}
