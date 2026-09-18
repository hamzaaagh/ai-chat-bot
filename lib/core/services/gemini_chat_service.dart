import 'package:ai_chat_bot/core/consts/backend_endpoints.dart';
import 'package:dio/dio.dart';

import '../models/message_model.dart';

class GeminiChatException implements Exception {
  const GeminiChatException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class GeminiChatService {
  GeminiChatService({
    String apiKey = "AIzaSyCAH0_6wIRpXpwPEfiQLfSLFjXeQaWe7h4",
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

  Future<MessageModel> sendMessages(List<MessageModel> messages) async {
    if (messages.isEmpty) {
      throw ArgumentError.value(
        messages,
        'messages',
        'At least one message is required.',
      );
    }

    final previousMessages = List<MessageModel>.of(_messages);
    _messages
      ..clear()
      ..addAll(messages);
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent',
        queryParameters: {'key': _apiKey},
        data: {'contents': _messages.map((item) => item.toJson()).toList()},
      );

      final assistantMessage = _assistantMessageFrom(response.data);
      _messages.add(assistantMessage);
      if (_messages.length >= 20) {
        _messages.sublist(_messages.length - 5);
      }
      return assistantMessage;
    } on DioException catch (error) {
      _messages
        ..clear()
        ..addAll(previousMessages);
      throw _exceptionFromDioError(error);
    } on GeminiChatException {
      _messages
        ..clear()
        ..addAll(previousMessages);
      rethrow;
    } on FormatException catch (error) {
      _messages
        ..clear()
        ..addAll(previousMessages);
      throw GeminiChatException(error.message);
    }
  }

  void clearHistory() {
    _messages.clear();
  }

  MessageModel _assistantMessageFrom(Map<String, dynamic>? data) {
    if (data == null) {
      throw const GeminiChatException('Gemini returned an empty response.');
    }

    final apiError = data['error'];
    if (apiError is Map) {
      throw GeminiChatException(_errorMessage(apiError));
    }

    final candidates = data['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      final blockReason = (data['promptFeedback'] as Map?)?['blockReason'];
      if (blockReason is String && blockReason.isNotEmpty) {
        throw GeminiChatException(
          'Gemini blocked the request: ${_humanize(blockReason)}.',
        );
      }
      throw const GeminiChatException('Gemini returned no candidates.');
    }

    final candidate = candidates.first;
    if (candidate is! Map) {
      throw const GeminiChatException('Gemini returned an invalid candidate.');
    }

    final content = candidate['content'];
    if (content is! Map) {
      final finishReason = candidate['finishReason'];
      if (finishReason is String && finishReason.isNotEmpty) {
        throw GeminiChatException(
          'Gemini did not return a response: ${_humanize(finishReason)}.',
        );
      }
      throw const GeminiChatException('Gemini returned no response content.');
    }

    final message = MessageModel.fromJson(Map<String, dynamic>.from(content));
    if (message.text.isEmpty) {
      throw const GeminiChatException('Gemini returned an empty response.');
    }

    return message;
  }

  GeminiChatException _exceptionFromDioError(DioException error) {
    final responseData = error.response?.data;
    if (responseData is Map) {
      final apiError = responseData['error'];
      if (apiError is Map) {
        return GeminiChatException(
          _errorMessage(apiError),
          statusCode: error.response?.statusCode,
        );
      }
    }

    final message = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        'The request to Gemini timed out. Please try again.',
      DioExceptionType.connectionError =>
        'Could not connect to Gemini. Check your internet connection.',
      _ => 'Gemini request failed. Please try again.',
    };

    return GeminiChatException(message, statusCode: error.response?.statusCode);
  }

  String _errorMessage(Map<dynamic, dynamic> error) {
    final message = error['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }

    final status = error['status'];
    if (status is String && status.isNotEmpty) {
      return 'Gemini request failed: ${_humanize(status)}.';
    }

    return 'Gemini request failed. Please try again.';
  }

  String _humanize(String value) {
    return value
        .replaceAll('_', ' ')
        .toLowerCase()
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }
}
