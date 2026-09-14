import 'package:ai_chat_bot/core/models/message_model.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/failure_message_bubble.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/loading_message_bubble.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({
    super.key,
    required this.messages,
    this.isLoading = false,
    this.failureMessage,
  });

  final List<MessageModel> messages;
  final bool isLoading;
  final String? failureMessage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length +
          (isLoading || failureMessage != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          if (isLoading) {
            return const LoadingMessageBubble();
          }

          return FailureMessageBubble(message: failureMessage!);
        }

        final message = messages[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == messages.length - 1 &&
                    !isLoading &&
                    failureMessage == null
                ? 0
                : 20,
          ),
          child: MessageBubble(
            text: message.text,
            isFromUser: message.role == 'user',
            time: '10:24 AM',
          ),
        );
      },
    );
  }
}
