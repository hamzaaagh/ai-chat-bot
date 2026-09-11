import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/send_message_repository.dart';
import 'send_message_state.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit(this._repository) : super(const SendMessageInitial());

  final SendMessageRepository _repository;

  Future<void> sendMessage(String text) async {
    emit(const SendMessageLoading());

    try {
      final message = await _repository.sendMessage(text);
      emit(SendMessageSuccess(message));
    } catch (error) {
      emit(SendMessageFailure(error.toString()));
    }
  }
}
