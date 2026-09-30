import 'package:ai_chat_bot/core/consts/backend_endpoints.dart';
import 'package:ai_chat_bot/core/models/message_model.dart';
import 'package:ai_chat_bot/core/services/api_client.dart';
import 'package:ai_chat_bot/core/services/gemini_chat_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ApiClientMock extends Mock implements ApiClient {}

DioException getRetryableDioExeption() {
  return DioException(
    requestOptions: RequestOptions(path: BackendEndpoints.baseUrl),
    type: DioExceptionType.connectionError,
  );
}

DioException getNonRetryableDioExeption() {
  return DioException(
    requestOptions: RequestOptions(path: BackendEndpoints.baseUrl),
    type: DioExceptionType.badResponse,
    response: Response<Map<String, dynamic>>(
      requestOptions: RequestOptions(path: BackendEndpoints.baseUrl),
      statusCode: 400,
    ),
  );
}

Future<Response<Map<String, dynamic>>> getSuccessResponse() async {
  return Response<Map<String, dynamic>>(
    requestOptions: RequestOptions(path: BackendEndpoints.baseUrl),
    statusCode: 200,
    data: {
      'candidates': [
        {
          'content': {
            'role': 'model',
            'parts': [
              {'text': 'Success response'},
            ],
          },
        },
      ],
    },
  );
}

void main() {
  late ApiClientMock apiClientMock;
  late GeminiChatService chatService;

  setUp(() {
    apiClientMock = ApiClientMock();
    chatService = GeminiChatService(apiClient: apiClientMock);
  });

  group('Retry Logic', () {
    test('Succeeded on first attempt', () async {
      when(
        () => apiClientMock.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer((_) async => getSuccessResponse());

      final result = await chatService.sendMessages([]);

      var callCount = verify(
        () => apiClientMock.post<Map<String, dynamic>>(
          any(),
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
        ),
      ).callCount;
      expect(callCount, equals(1));
      expect(result, isA<MessageModel>());
    });
    test(
      'failed on first attempt but succeeded on second attempt with retryable error',
      () async {
        var counter = 0;
        when(
          () => apiClientMock.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).thenAnswer((_) async {
          counter++;
          if (counter == 1) {
            throw getRetryableDioExeption();
          }
          return getSuccessResponse();
        });

        final result = await chatService.sendMessages([]);

        var callCount = verify(
          () => apiClientMock.post<Map<String, dynamic>>(
            any(),
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
          ),
        ).callCount;
        expect(callCount, equals(2));
        expect(result, isA<MessageModel>());
      },
    );
  });
  test('failed on first attempt , not retryable error', () async {
    when(
      () => apiClientMock.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async {
      throw getNonRetryableDioExeption();
    });

    await expectLater(
      chatService.sendMessages([]),
      throwsA(isA<DioException>()),
    );

    var callCount = verify(
      () => apiClientMock.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).callCount;
    expect(callCount, equals(1));
  });




  test("failed on second attempt , succeed on third with retryable error", () async {
    var counter = 0;
    when(
      () => apiClientMock.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async {
      counter++;
          if (counter == 3) {
            return getSuccessResponse();
          }
          throw getRetryableDioExeption();
    });

   var result = await chatService.sendMessages([]);

    var callCount = verify(
      () => apiClientMock.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).callCount;
    expect(callCount, equals(3));
    expect(result, isA<MessageModel>());
  });
   test('failed on third attempt , with retryable error', () async {
    when(
      () => apiClientMock.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer((_) async {
      throw getRetryableDioExeption();
    });

    await expectLater(
      chatService.sendMessages([]),
      throwsA(isA<DioException>()),
    );

    var callCount = verify(
      () => apiClientMock.post<Map<String, dynamic>>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
      ),
    ).callCount;
    expect(callCount, equals(3));
  });
}
