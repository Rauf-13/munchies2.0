// lib/screens/chat/ai_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_menu_items.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wellness_provider.dart';
import '../../models/menu_item.dart';
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
  bool _showTypingIndicator = false;

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      "Hey! 👋 I'm NomNom, your AI food assistant. Tell me what you're craving and I'll find something great for you!",
      showChips: true,
    );
  }

  _BotResponse _generateResponse(String input) {
    final msg = input.toLowerCase().trim();
    final wellness = context.read<WellnessProvider>();

    List<MenuItem> available = wellness.isEnabled
        ? dummyMenuItems
              .where((m) => !wellness.itemConflicts([m.name, ...m.tags]))
              .toList()
        : List.from(dummyMenuItems);

    // ── Budget ──
    final budgetMatch = RegExp(r'(\d+)').firstMatch(msg);
    if (msg.contains('budget') ||
        msg.contains('cheap') ||
        msg.contains('affordable') ||
        msg.contains('under') ||
        msg.contains('less than') ||
        msg.contains('below')) {
      int budget = 2000;
      if (budgetMatch != null) {
        budget = int.tryParse(budgetMatch.group(1)!) ?? 2000;
      }
      final affordable = available.where((m) => m.price <= budget).toList();
      if (affordable.isEmpty) {
        final cheapest = List<MenuItem>.from(available)
          ..sort((a, b) => a.price.compareTo(b.price));
        return _BotResponse(
          "Nothing under ₦$budget right now, but our most affordable option is ${cheapest.first.name} at ₦${cheapest.first.price.toStringAsFixed(0)} — still great value! 💰",
          cheapest.take(2).toList(),
        );
      }
      affordable.sort((a, b) => a.price.compareTo(b.price));
      return _BotResponse(
        "Found ${affordable.length} options under ₦$budget! Here are the best value picks 💰",
        affordable.take(2).toList(),
      );
    }

    // ── Heavy / filling / starving ──
    if (msg.contains('heavy') ||
        msg.contains('filling') ||
        msg.contains('starving') ||
        msg.contains('very hungry') ||
        msg.contains('so hungry') ||
        msg.contains('pounded') ||
        msg.contains('amala') ||
        msg.contains('swallow')) {
      final heavy = available
          .where((m) => m.tags.any((t) => t.toLowerCase().contains('heavy')))
          .toList();
      final picks = heavy.isNotEmpty ? heavy : available.take(2).toList();
      return _BotResponse(
        "You need something serious! 😤 These heavy meals will sort you out:",
        picks,
      );
    }

    // ── Rice ──
    if (msg.contains('rice') ||
        msg.contains('jollof') ||
        msg.contains('fried rice') ||
        msg.contains('ofada')) {
      final rice = available
          .where(
            (m) =>
                m.category.toLowerCase().contains('rice') ||
                m.name.toLowerCase().contains('rice'),
          )
          .toList();
      return _BotResponse(
        "Rice lover! 🍚 Here's what we've got:",
        rice.take(2).toList(),
      );
    }

    // ── Local / Nigerian ──
    if (msg.contains('local') ||
        msg.contains('nigerian') ||
        msg.contains('naija') ||
        msg.contains('egusi') ||
        msg.contains('beans') ||
        msg.contains('plantain') ||
        msg.contains('dodo')) {
      final local = available
          .where(
            (m) =>
                m.category.toLowerCase().contains('swallow') ||
                m.category.toLowerCase().contains('popular') ||
                m.name.toLowerCase().contains('amala') ||
                m.name.toLowerCase().contains('beans') ||
                m.name.toLowerCase().contains('ofada'),
          )
          .toList();
      final picks = local.isNotEmpty ? local : available.take(2).toList();
      return _BotResponse(
        "Nothing beats good Naija food! 🍛 Here's what I'd recommend:",
        picks,
      );
    }

    // ── Best seller / popular / recommended ──
    if (msg.contains('popular') ||
        msg.contains('best') ||
        msg.contains('top') ||
        msg.contains('recommended') ||
        msg.contains('favourite') ||
        msg.contains('favorite')) {
      final popular = available
          .where(
            (m) => m.tags.any(
              (t) =>
                  t.toLowerCase().contains('best seller') ||
                  t.toLowerCase().contains('popular'),
            ),
          )
          .toList();
      final picks = popular.isNotEmpty ? popular : available.take(2).toList();
      return _BotResponse(
        "These are our most loved meals right now ⭐ Students keep coming back for these:",
        picks,
      );
    }

    // ── Student special ──
    if (msg.contains('student') ||
        msg.contains('school') ||
        msg.contains('lecture') ||
        msg.contains('broke')) {
      final student = available
          .where(
            (m) => m.tags.any(
              (t) =>
                  t.toLowerCase().contains('student') ||
                  t.toLowerCase().contains('budget'),
            ),
          )
          .toList();
      final picks = student.isNotEmpty ? student : available.take(2).toList();
      return _BotResponse(
        "I got you, student life is real 😅 Here are the best value meals on campus:",
        picks,
      );
    }

    // ── Protein / meat / chicken / turkey ──
    if (msg.contains('protein') ||
        msg.contains('meat') ||
        msg.contains('chicken') ||
        msg.contains('turkey') ||
        msg.contains('fish') ||
        msg.contains('beef')) {
      final protein = available
          .where(
            (m) =>
                m.tags.any((t) => t.toLowerCase().contains('protein')) ||
                m.name.toLowerCase().contains('turkey') ||
                m.name.toLowerCase().contains('chicken') ||
                m.description.toLowerCase().contains('chicken') ||
                m.description.toLowerCase().contains('turkey'),
          )
          .toList();
      final picks = protein.isNotEmpty ? protein : available.take(2).toList();
      return _BotResponse(
        "Need that protein hit! 💪 These meals come loaded with meat:",
        picks,
      );
    }

    // ── Greetings ──
    if (msg == 'hi' ||
        msg == 'hello' ||
        msg == 'hey' ||
        msg == 'yo' ||
        msg == 'sup' ||
        msg.contains('good morning') ||
        msg.contains('good afternoon') ||
        msg.contains('good evening')) {
      return _BotResponse(
        "Hey! 👋 Great to see you. Are you in the mood for something local, rice, swallow, or are you on a budget today?",
        [],
        showChips: true,
      );
    }

    // ── Thanks ──
    if (msg.contains('thank') ||
        msg.contains('nice') ||
        msg.contains('great')) {
      return _BotResponse(
        "You're welcome! 😊 Enjoy your meal — tap the + on any card to add it to your cart!",
        [],
      );
    }

    // ── Show menu / what do you have ──
    if (msg.contains('menu') ||
        msg.contains('options') ||
        msg.contains('what do you have') ||
        msg.contains('show me') ||
        msg.contains('what can')) {
      return _BotResponse(
        "Here's a taste of what's available today 😋 We've got rice meals, swallow, and some great budget picks:",
        available.take(2).toList(),
      );
    }

    // ── Default — show best sellers ──
    final bestSellers = available
        .where(
          (m) => m.tags.any(
            (t) =>
                t.toLowerCase().contains('best seller') ||
                t.toLowerCase().contains('popular'),
          ),
        )
        .toList();
    final picks = bestSellers.isNotEmpty
        ? bestSellers
        : available.take(2).toList();
    return _BotResponse(
      "Let me suggest some of our most popular options right now 🍽️",
      picks,
    );
  }

  void _simulateBotResponse(String userMessage) {
    setState(() => _showTypingIndicator = true);

    final delay = Duration(
      milliseconds: 1000 + (userMessage.length * 10).clamp(0, 800),
    );

    Future.delayed(delay, () {
      if (!mounted) return;
      setState(() => _showTypingIndicator = false);

      final response = _generateResponse(userMessage);
      _addBotMessage(
        response.text,
        showSuggestions: response.items.isNotEmpty,
        suggestedItems: response.items.map((m) => m.id).toList(),
        showChips: response.showChips,
      );
    });
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
    _simulateBotResponse(message);
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
              setState(() => _messages.clear());
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
                              emoji: '🍚',
                              label: 'Rice meals',
                              onTap: () =>
                                  _addUserMessage('Show me rice options'),
                            ),
                            SuggestionChip(
                              emoji: '🍛',
                              label: 'Local food',
                              onTap: () =>
                                  _addUserMessage('I want local Nigerian food'),
                            ),
                            SuggestionChip(
                              emoji: '😤',
                              label: 'Heavy meal',
                              onTap: () => _addUserMessage(
                                'I need something heavy and filling',
                              ),
                            ),
                            SuggestionChip(
                              emoji: '💰',
                              label: 'Budget',
                              onTap: () => _addUserMessage(
                                'What can I get under ₦2000?',
                              ),
                            ),
                          ],
                        ),
                      ),

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

class _BotResponse {
  final String text;
  final List<MenuItem> items;
  final bool showChips;

  _BotResponse(this.text, this.items, {this.showChips = false});
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
