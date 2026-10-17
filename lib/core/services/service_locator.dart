import 'package:ai_chat_bot/core/services/api_client.dart';
import 'package:ai_chat_bot/core/services/gemini_chat_service.dart';
import 'package:ai_chat_bot/features/chat/data/repositories/send_message_repository_impl.dart';
import 'package:ai_chat_bot/features/chat/domain/repositories/send_message_repository.dart';
import 'package:ai_chat_bot/features/chat/presentation/cubit/send_message_cubit.dart';
import 'package:get_it/get_it.dart';

var getIt = GetIt.instance;
void setupServiceLocator() {
  getIt.registerSingleton<ApiClient>(ApiClient());
  getIt.registerSingleton<GeminiChatService>(
    GeminiChatService(apiClient: getIt<ApiClient>()),
  );
  getIt.registerSingleton<SendMessageRepository>(
    SendMessageRepositoryImpl(getIt<GeminiChatService>()),
  );
  getIt.registerFactory<SendMessageCubit>(
    () => SendMessageCubit(getIt<SendMessageRepository>()),
  );
}
