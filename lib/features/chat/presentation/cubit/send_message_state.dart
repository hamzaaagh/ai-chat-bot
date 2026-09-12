import 'package:ai_chat_bot/core/models/message_model.dart';

sealed class SendMessageState {
  const SendMessageState(this.messages);

  final List<MessageModel> messages;
}

final class SendMessageInitial extends SendMessageState {
  const SendMessageInitial(super.messages);
}

final class SendMessageLoading extends SendMessageState {
  const SendMessageLoading(super.messages);
}

final class SendMessageSuccess extends SendMessageState {
  const SendMessageSuccess(super.messages, this.message);

  final MessageModel message;
}

final class SendMessageFailure extends SendMessageState {
  const SendMessageFailure(super.messages, this.message);

  final String message;
}
