import 'package:ai_chat_bot/core/models/message_model.dart';
import 'package:ai_chat_bot/core/services/gemini_chat_service.dart';
import 'package:ai_chat_bot/features/chat/domain/repositories/send_message_repository.dart';

class SendMessageRepositoryImpl implements SendMessageRepository {
  const SendMessageRepositoryImpl(this._chatService);

  final GeminiChatService _chatService;

  @override
  Future<MessageModel> sendMessage(String text) {
    return _chatService.sendMessages(text);
  }
}
