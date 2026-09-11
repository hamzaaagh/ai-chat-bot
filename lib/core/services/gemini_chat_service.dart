import 'package:ai_chat_bot/core/consts/backend_endpoints.dart';
import 'package:dio/dio.dart';

import '../models/message_model.dart';

class GeminiChatService {
  GeminiChatService({
    required String apiKey,
    Dio? dio,
    this.model = BackendEndpoints.aiModel,
  }) : _apiKey = apiKey.trim(),
       _dio = dio ?? Dio() {
    if (_apiKey.isEmpty) {
      throw ArgumentError.value(
        apiKey,
        'apiKey',
        'The Gemini API key is required.',
      );
    }
  }

  final String _apiKey;
  final Dio _dio;
  final String model;
  final List<MessageModel> _messages = [];

  List<MessageModel> get messages => List.unmodifiable(_messages);

  Future<MessageModel> sendMessages(String text) async {
    final message = text.trim();
    if (message.isEmpty) {
      throw ArgumentError.value(text, 'text', 'A message cannot be empty.');
    }

    final userMessage = MessageModel.user(message);
    _messages.add(userMessage);

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
        queryParameters: {'key': _apiKey},
        data: {'contents': _messages.map((item) => item.toJson()).toList()},
      );

      final assistantMessage = _assistantMessageFrom(response.data);
      _messages.add(assistantMessage);
      return assistantMessage;
    } catch (_) {
      _messages.remove(userMessage);
      rethrow;
    }
  }

  void clearHistory() {
    _messages.clear();
  }

  MessageModel _assistantMessageFrom(Map<String, dynamic>? data) {
    final candidates = data?['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw const FormatException('Gemini returned no candidates.');
    }

    final candidate = candidates.first;
    if (candidate is! Map) {
      throw const FormatException('Gemini returned an invalid candidate.');
    }

    final content = candidate['content'];
    if (content is! Map) {
      throw const FormatException('Gemini returned no response content.');
    }

    final message = MessageModel.fromJson(Map<String, dynamic>.from(content));
    if (message.text.isEmpty) {
      throw const FormatException('Gemini returned an empty response.');
    }

    return message;
  }
}
