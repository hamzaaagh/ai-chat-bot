import 'package:ai_chat_bot/core/models/message_model.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key, required this.messages});

  final List<MessageModel> messages;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == messages.length - 1 ? 0 : 20,
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
