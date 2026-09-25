import 'package:ai_chat_bot/core/consts/backend_endpoints.dart';
import 'package:dio/dio.dart';

import '../models/message_model.dart';
import 'api_client.dart';

class GeminiChatService {
  GeminiChatService({
    String apiKey = 'AIzaSyCAH0_6wIRpXpwPEfiQLfSLFjXeQaWe7h4',
    ApiClient? apiClient,
    Dio? dio,
    this.model = BackendEndpoints.aiModel,
    this.baseUrl = BackendEndpoints.baseUrl,
  }) : _apiKey = apiKey,
       _apiClient = apiClient ?? ApiClient(dio: dio);

  final String _apiKey;
  final ApiClient _apiClient;
  final String baseUrl;
  final String model;

  Future<MessageModel> sendMessages(List<MessageModel> messages) async {
    late DioException exception;
    for (var i = 0; i < 3; i++) {
      try {
        final response = await _apiClient.post<Map<String, dynamic>>(
          baseUrl,
          queryParameters: {'key': _apiKey},
          data: {
            'contents': messages.map((message) => message.toJson()).toList(),
          },
        );
        final candidate =
            (response.data!['candidates'] as List).first
                as Map<String, dynamic>;
        return MessageModel.fromJson(
          Map<String, dynamic>.from(candidate['content'] as Map),
        );
      } on DioException catch (e) {
        exception = e;
        if (!_isRetryableError(e) || i == 2) rethrow;
        await Future.delayed(Duration(seconds: i + 1));
      }
    }
    throw exception;
  }
}

bool _isRetryableError(DioException error) {
  final statusCode = error.response?.statusCode;

  return switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError => true,
        _ => false,
      } ||
      statusCode == 408 ||
      statusCode == 429 ||
      (statusCode != null && statusCode >= 500);
}
