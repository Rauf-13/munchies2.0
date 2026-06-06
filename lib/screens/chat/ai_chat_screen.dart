// lib/screens/chat/ai_chat_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_menu_items.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wellness_provider.dart';
import 'widgets/message_bubble.dart';
import 'widgets/suggestion_chip.dart';
import 'widgets/food_suggestion_card.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final List<Map<String, String>> _conversationHistory = [];
  bool _showTypingIndicator = false;

  static const String _groqUrl =
      'https://api.groq.com/openai/v1/chat/completions';

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "Hey! 👋 I'm NomNom, your AI food assistant. Tell me what you're craving and I'll find something great for you!",
      showChips: true,
    );
  }

  String _buildSystemPrompt() {
    final wellness = context.read<WellnessProvider>();
    final menuList = dummyMenuItems
        .map(
          (m) =>
              '- ${m.name} (₦${m.price.toStringAsFixed(0)}): ${m.description}. Tags: ${m.tags.join(', ')}',
        )
        .join('\n');

    String wellnessContext = '';
    if (wellness.isEnabled && wellness.dietaryRestrictions.isNotEmpty) {
      wellnessContext =
          '\nUser dietary restrictions: ${wellness.dietaryRestrictions.join(', ')}. Avoid suggesting conflicting items.';
    }

    return '''You are NomNom, a friendly AI food ordering assistant for Munchies, a student food delivery app in Kano, Nigeria. 
You help students find meals that match their cravings and budget.

Available menu items:
$menuList
$wellnessContext

Rules:
- Keep responses short, friendly and conversational — max 2-3 sentences
- Always suggest specific meals from the menu above by name
- Mention prices in Naira (₦)
- You understand Nigerian food culture and student budgets
- If asked about something not on the menu, suggest the closest available option
- Never make up menu items that aren't listed above
- If the user mentions a budget, only suggest items within that budget''';
  }

  Future<void> _sendToGroq(String userMessage) async {
    setState(() => _showTypingIndicator = true);

    _conversationHistory.add({'role': 'user', 'content': userMessage});

    try {
      final apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

      final response = await http.post(
        Uri.parse(_groqUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama3-8b-8192',
          'messages': [
            {'role': 'system', 'content': _buildSystemPrompt()},
            ..._conversationHistory,
          ],
          'max_tokens': 200,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content']
            .toString()
            .trim();

        _conversationHistory.add({'role': 'assistant', 'content': reply});

        setState(() => _showTypingIndicator = false);

        // Check if reply mentions any menu items and show suggestion cards
        final mentionedItems = dummyMenuItems
            .where(
              (item) => reply.toLowerCase().contains(item.name.toLowerCase()),
            )
            .take(2)
            .toList();

        _addBotMessage(
          reply,
          showSuggestions: mentionedItems.isNotEmpty,
          suggestedItems: mentionedItems.map((e) => e.id).toList(),
        );
      } else {
        setState(() => _showTypingIndicator = false);
        _addBotMessage(
          "Sorry, I'm having trouble connecting right now. Try again in a moment!",
        );
      }
    } catch (e) {
      setState(() => _showTypingIndicator = false);
      _addBotMessage(
        "Hmm, something went wrong. Check your connection and try again.",
      );
    }
  }

  void _addBotMessage(
    String message, {
    bool showChips = false,
    bool showSuggestions = false,
    List<String> suggestedItems = const [],
  }) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isUser: false,
          showChips: showChips,
          showSuggestions: showSuggestions,
          suggestedItemIds: suggestedItems,
        ),
      );
    });
    _scrollToBottom();
  }

  void _addUserMessage(String message) {
    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _messageController.clear();
    });
    _scrollToBottom();
    _sendToGroq(message);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFFFEF3C7),
              child: const Text('🤖', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NomNom AI',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () {
              setState(() {
                _messages.clear();
                _conversationHistory.clear();
              });
              _addBotMessage(
                "Hey! 👋 Fresh start! What are you craving today?",
                showChips: true,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _messages.length + (_showTypingIndicator ? 1 : 0),
              itemBuilder: (context, index) {
                if (_showTypingIndicator && index == _messages.length) {
                  return _buildTypingIndicator();
                }

                final message = _messages[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MessageBubble(
                      message: message.text,
                      isUser: message.isUser,
                    ),

                    // Quick reply chips after first message
                    if (message.showChips && !message.isUser)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 60,
                          right: 16,
                          top: 8,
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            SuggestionChip(
                              emoji: '🌶️',
                              label: 'Spicy',
                              onTap: () => _addUserMessage(
                                'I want something spicy under ₦1500',
                              ),
                            ),
                            SuggestionChip(
                              emoji: '🍔',
                              label: 'Fast food',
                              onTap: () =>
                                  _addUserMessage('Show me fast food options'),
                            ),
                            SuggestionChip(
                              emoji: '🍛',
                              label: 'Local',
                              onTap: () =>
                                  _addUserMessage('I want local Nigerian food'),
                            ),
                            SuggestionChip(
                              emoji: '💰',
                              label: 'Budget',
                              onTap: () => _addUserMessage(
                                'What can I get under ₦1000?',
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Food suggestion cards when AI mentions menu items
                    if (message.showSuggestions &&
                        !message.isUser &&
                        message.suggestedItemIds.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 60,
                          right: 16,
                          top: 12,
                        ),
                        child: Column(
                          children: message.suggestedItemIds.map((id) {
                            final meal = dummyMenuItems.firstWhere(
                              (m) => m.id == id,
                              orElse: () => dummyMenuItems.first,
                            );
                            return FoodSuggestionCard(
                              meal: meal,
                              onAdd: () {
                                context.read<CartProvider>().addItem(
                                  meal,
                                  vendorId: meal.vendorId,
                                  vendorName: 'Vendor',
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${meal.name} added to cart!',
                                    ),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.border, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ask me anything about food...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) {
                          _addUserMessage(value.trim());
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _addUserMessage(_messageController.text.trim());
                    }
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFFEF3C7),
            child: const Text('🤖', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(200),
                const SizedBox(width: 4),
                _buildDot(400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int delay) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      builder: (context, double value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.textSecondary.withOpacity(value),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool showChips;
  final bool showSuggestions;
  final List<String> suggestedItemIds;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.showChips = false,
    this.showSuggestions = false,
    this.suggestedItemIds = const [],
  });
}
