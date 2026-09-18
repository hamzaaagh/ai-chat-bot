import 'package:ai_chat_bot/core/models/message_model.dart';

abstract interface class SendMessageRepository {
  Future<MessageModel> sendMessage(List<MessageModel> messages);
}
