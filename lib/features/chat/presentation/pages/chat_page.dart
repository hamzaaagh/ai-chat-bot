import 'package:ai_chat_bot/core/services/gemini_chat_service.dart';
import 'package:ai_chat_bot/features/chat/data/repositories/send_message_repository_impl.dart';
import 'package:ai_chat_bot/features/chat/presentation/cubit/send_message_cubit.dart';
import 'package:ai_chat_bot/features/chat/presentation/cubit/send_message_state.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/chat_composer.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/messages_list_view.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/suggestion_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> { 
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SendMessageCubit(SendMessageRepositoryImpl(GeminiChatService())),
      child: BlocListener<SendMessageCubit, SendMessageState>(
        listener: (context, state) {
          if (state case SendMessageFailure(:final message)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        child: Scaffold(
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
                        children: [
                          const _WelcomeHeader(),
                          const SizedBox(height: 32),
                          BlocBuilder<SendMessageCubit, SendMessageState>(
                            builder: (context, state) {
                              return MessagesListView(
                                messages: state.messages,
                              );
                            },
                          ),
                          const SizedBox(height: 28),
                          const Text(
                          'Try asking',
                          style: TextStyle(
                            color: Color(0xFF77727D),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          ),
                          const SizedBox(height: 12),
                          const Wrap(
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
                    BlocBuilder<SendMessageCubit, SendMessageState>(
                      builder: (context, state) {
                        return ChatComposer(
                          isLoading: state is SendMessageLoading,
                          onSend: context
                              .read<SendMessageCubit>()
                              .sendMessage,
                        );
                      },
                    ),
                  ],
                ),
              ),
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
          style: TextStyle(color: Color(0xFF77727D), fontSize: 15),
        ),
      ],
    );
  }
}
