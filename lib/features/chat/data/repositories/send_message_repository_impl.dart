import 'package:ai_chat_bot/core/models/message_model.dart';
import 'package:ai_chat_bot/core/services/gemini_chat_service.dart';
import 'package:ai_chat_bot/features/chat/domain/repositories/send_message_repository.dart';

class SendMessageRepositoryImpl implements SendMessageRepository {
  const SendMessageRepositoryImpl(this._chatService);

  final GeminiChatService _chatService;

  @override
  Future<MessageModel> sendMessage(List<MessageModel> messages) {
    if (messages.length > 20) {
      messages = messages.sublist(messages.length - 5);
    }
    return _chatService.sendMessages(messages);
  }
}
