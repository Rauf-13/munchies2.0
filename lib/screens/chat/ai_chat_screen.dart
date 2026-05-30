import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/dummy_menu_items.dart';
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
    // Initial greeting
    _addBotMessage(
      "Hey! 👋 I'm here to help you find delicious food. What are you craving today?",
      showChips: true,
    );
  }

  void _addBotMessage(
    String message, {
    bool showChips = false,
    bool showSuggestions = false,
  }) {
    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isUser: false,
          showChips: showChips,
          showSuggestions: showSuggestions,
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

    // Simulate bot response
    _simulateBotResponse(message);
  }

  void _simulateBotResponse(String userMessage) {
    setState(() {
      _showTypingIndicator = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showTypingIndicator = false;
      });

      if (userMessage.toLowerCase().contains('spicy')) {
        _addBotMessage(
          "Perfect! I found some spicy options within your budget. Here are my top picks:",
          showSuggestions: true,
        );
      } else {
        _addBotMessage("Great choice! Let me find the best options for you...");
      }
    });
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

  void _handleChipTap(String chipText) {
    _addUserMessage(chipText);
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
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages Area
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

                    // Show chips after bot message
                    if (message.showChips && !message.isUser) ...[
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
                              onTap: () => _handleChipTap(
                                'I want something spicy under ₦1500',
                              ),
                            ),
                            SuggestionChip(
                              emoji: '🍔',
                              label: 'Fast food',
                              onTap: () => _handleChipTap('Fast food'),
                            ),
                            SuggestionChip(
                              emoji: '🍛',
                              label: 'Local',
                              onTap: () => _handleChipTap('Local cuisine'),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Show food suggestions
                    if (message.showSuggestions && !message.isUser) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 60,
                          right: 16,
                          top: 12,
                        ),
                        child: Column(
                          children: [
                            ...dummyMenuItems.take(2).map((meal) {
                              return FoodSuggestionCard(
                                meal: meal,
                                onAdd: () {
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

                            // Bottom action chips
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: const Color(0xFFFEF3C7),
                                    child: const Text(
                                      '🤖',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  SuggestionChip(
                                    emoji: '',
                                    label: 'Show more',
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 8),
                                  SuggestionChip(
                                    emoji: '⭐',
                                    label: 'Top rated',
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 8),
                                  SuggestionChip(
                                    emoji: '🚀',
                                    label: 'Fas',
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                // Camera Icon
                IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, size: 24),
                  color: AppColors.textSecondary,
                  onPressed: () {},
                ),

                // Microphone Icon
                IconButton(
                  icon: const Icon(Icons.mic_outlined, size: 24),
                  color: AppColors.textSecondary,
                  onPressed: () {},
                ),

                const SizedBox(width: 8),

                // Text Input
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
                        hintText: 'Type your message...',
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

                // Send Button
                GestureDetector(
                  onTap: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      _addUserMessage(_messageController.text.trim());
                    }
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
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
      onEnd: () {
        setState(() {});
      },
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

  ChatMessage({
    required this.text,
    required this.isUser,
    this.showChips = false,
    this.showSuggestions = false,
  });
}
