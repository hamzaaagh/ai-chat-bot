import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ai_chat_bot/core/models/message_model.dart';
import '../../domain/repositories/send_message_repository.dart';
import 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit(this._repository)
    : super(
        const SendMessageInitial([
          MessageModel(
            role: 'model',
            text:
                'Hello! I am Luma, your AI assistant. How can I help you today?',
          ),
          MessageModel(
            role: 'model',
            text:
                'I would love to help you plan, write, learn, or simply think through an idea.',
          ),
        ]),
      );

  final SendMessageRepository _repository;

  Future<void> sendMessage(String text) async {
    final message = text.trim();
    if (message.isEmpty || state is SendMessageLoading) {
      return;
    }

    final messages = [...state.messages, MessageModel.user(message)];
    emit(SendMessageLoading(List.unmodifiable(messages)));

    try {
      final assistantMessage = await _repository.sendMessage(messages);
      final updatedMessages = [...messages, assistantMessage];
      emit(
        SendMessageSuccess(
          List.unmodifiable(updatedMessages),
          assistantMessage,
        ),
      );
    } catch (error) {
      emit(SendMessageFailure(List.unmodifiable(messages), error.toString()));
    }
  }
}
