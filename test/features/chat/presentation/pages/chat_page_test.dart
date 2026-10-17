import 'package:ai_chat_bot/core/models/message_model.dart';
import 'package:ai_chat_bot/core/services/service_locator.dart';
import 'package:ai_chat_bot/features/chat/domain/repositories/send_message_repository.dart';
import 'package:ai_chat_bot/features/chat/presentation/cubit/send_message_cubit.dart';
import 'package:ai_chat_bot/features/chat/presentation/pages/chat_page.dart';
import 'package:ai_chat_bot/features/chat/presentation/widgets/loading_message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendMessageRepo extends Mock implements SendMessageRepository {}

MessageModel getMaessageMoodel() => MessageModel.user('test');
void main() {
  late MockSendMessageRepo mockSendMessageRepo;
  setUp(() async {
    mockSendMessageRepo = MockSendMessageRepo();
    await getIt.reset();
    getIt.registerSingleton<SendMessageRepository>(mockSendMessageRepo);
    getIt.registerFactory(
      () => SendMessageCubit(getIt<SendMessageRepository>()),
    );
  });

  group('SendMessageFlow', () {
    testWidgets("Loading Indicator on Send", (tester) async {
      when(() => mockSendMessageRepo.sendMessage(any())).thenAnswer(
        (_) async => Future.delayed(
          const Duration(seconds: 2),
          () => getMaessageMoodel(),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: ChatPage()));
      await tester.pumpAndSettle();
      var textField = find.byKey(const Key("chat_input_text_field"));
      await tester.enterText(textField, "Hello");
      await tester.pumpAndSettle();
      var sendButton = find.byIcon(Icons.arrow_upward_rounded);
      await tester.tap(sendButton);
      await tester.pump();
      expect(find.byType(LoadingMessageBubble), findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
