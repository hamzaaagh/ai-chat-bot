import 'package:ai_chat_bot/core/models/message_model.dart';

sealed class SendMessageState {
  const SendMessageState();
}

final class SendMessageInitial extends SendMessageState {
  const SendMessageInitial();
}

final class SendMessageLoading extends SendMessageState {
  const SendMessageLoading();
}

final class SendMessageSuccess extends SendMessageState {
  const SendMessageSuccess(this.message);

  final MessageModel message;
}

final class SendMessageFailure extends SendMessageState {
  const SendMessageFailure(this.message);

  final String message;
}
