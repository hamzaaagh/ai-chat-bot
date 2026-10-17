import 'package:ai_chat_bot/core/services/service_locator.dart';
import 'package:ai_chat_bot/features/chat/presentation/cubit/send_message_cubit.dart';
import 'package:ai_chat_bot/features/chat/presentation/cubit/send_message_state.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/chat_app_bar.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/chat_composer.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/messages_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SendMessageCubit>(),
      child: BlocListener<SendMessageCubit, SendMessageState>(
        listener: (_, __) => _scrollToBottom(),
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
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                        children: [
                          _welcomeHeader(context),
                          const SizedBox(height: 32),
                          _messagesList(),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                    _composer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Widget _messagesList() {
    return BlocBuilder<SendMessageCubit, SendMessageState>(
      builder: (_, state) => MessagesListView(
        messages: state.messages,
        isLoading: state is SendMessageLoading,
        failureMessage: state is SendMessageFailure ? state.message : null,
      ),
    );
  }

  Widget _composer() {
    return BlocBuilder<SendMessageCubit, SendMessageState>(
      builder: (context, state) => ChatComposer(
        isLoading: state is SendMessageLoading,
        onSend: context.read<SendMessageCubit>().sendMessage,
      ),
    );
  }

  Widget _welcomeHeader(BuildContext context) {
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
