import 'package:ai_chat_bot/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/chat_composer.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/message_bubble.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/suggestion_chip.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChatAppBar(),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                    children: const [
                      _WelcomeHeader(),
                      SizedBox(height: 32),
                      MessageBubble(
                        text:
                            'Hello! I am Luma, your AI assistant. How can I help you today?',
                        isFromUser: false,
                        time: '10:24 AM',
                      ),
                      SizedBox(height: 20),
                      MessageBubble(
                        text:
                            'I would love to help you plan, write, learn, or simply think through an idea.',
                        isFromUser: false,
                        time: '10:24 AM',
                      ),
                      SizedBox(height: 28),
                      Text(
                        'Try asking',
                        style: TextStyle(
                          color: Color(0xFF77727D),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          SuggestionChip(
                            icon: Icons.lightbulb_outline_rounded,
                            label: 'Brainstorm ideas',
                          ),
                          SuggestionChip(
                            icon: Icons.edit_note_rounded,
                            label: 'Help me write',
                          ),
                          SuggestionChip(
                            icon: Icons.menu_book_outlined,
                            label: 'Explain a topic',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const ChatComposer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, there',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF27232D),
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        const Text(
          'What would you like to explore today?',
          style: TextStyle(
            color: Color(0xFF77727D),
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
