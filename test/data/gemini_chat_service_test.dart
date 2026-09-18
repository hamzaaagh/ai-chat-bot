import 'package:ai_chat_bot/core/models/message_model.dart';
import 'package:ai_chat_bot/core/services/gemini_chat_service.dart';
import 'package:ai_chat_bot/features/chat/data/repositories/send_message_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class GeminiChatServiceMock extends Mock implements GeminiChatService {}

MessageModel getMessageModel() => MessageModel(role: "user", text: "test");

void main() {
  late SendMessageRepositoryImpl repository;
  late GeminiChatServiceMock chatServiceMock;
  setUp(() {
    chatServiceMock = GeminiChatServiceMock();
    repository = SendMessageRepositoryImpl(chatServiceMock);
  });
  group("validation logic in sending message", () {
    test(
      "messages length does not change in case message less than or equal to 20",
      () async {
        when(
          () => chatServiceMock.sendMessages(any()),
        ).thenAnswer((_) async => getMessageModel());
        final messages = List.generate(20, (index) => getMessageModel());
        var result = await repository.sendMessage(messages);
        var capturedMessages =
            verify(
                  () => chatServiceMock.sendMessages(captureAny()),
                ).captured.first
                as List<MessageModel>;

        expect(capturedMessages.length, equals(messages.length));
      },
    );
    test(
      "messages length reduced to 5 in case message greater than 20",
      () async {
        when(
          () => chatServiceMock.sendMessages(any()),
        ).thenAnswer((_) async => getMessageModel());
        final messages = List.generate(30, (index) => getMessageModel());
        var result = await repository.sendMessage(messages);
        var capturedMessages =
            verify(
                  () => chatServiceMock.sendMessages(captureAny()),
                ).captured.first
                as List<MessageModel>;

        expect(capturedMessages.length, equals(5));
      },
    );
  });
}
