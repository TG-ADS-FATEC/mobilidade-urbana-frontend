import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobilidade_urbana_app/core/data_state/data_state.dart';
import 'package:mobilidade_urbana_app/core/error/failures.dart';
import 'package:mobilidade_urbana_app/core/services/auth_service.dart';
import 'package:mobilidade_urbana_app/core/services/device_token_service.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockDio = MockDio();
  });

  Response<dynamic> _okResponse(Map<String, dynamic> body) => Response(
    requestOptions: RequestOptions(path: ''),
    statusCode: 200,
    data: body,
  );

  DioException _dioError(DioExceptionType type, {String? message}) =>
    DioException(
      requestOptions: RequestOptions(path: ''),
      type: type,
      message: message,
    );

    group('authenticate() — sucesso', () {
      test('retorna DataSuccess com o jwt da resposta', () async {
        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => _okResponse({'token': 'fake-jwt-abc'}));

        final result = await AuthService.authenticate(dio: mockDio);

        expect(result, isA<DataSuccess<List<String>>>());
        expect((result as DataSuccess<List<String>>).data[0], equals('fake-jwt-abc'));
      });

      test('salva o jwt no DeviceTokenService após autenticar', () async {
        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => _okResponse({'token': 'stored-jwt'}));

        await AuthService.authenticate(dio: mockDio);

        expect(await DeviceTokenService.getJwt(), equals('stored-jwt'));
      });

      test('jwt retornado no DataSuccess é o mesmo salvo no storage', () async {
        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((_) async => _okResponse({'token': 'consistent-jwt'}));

        final result = await AuthService.authenticate(dio: mockDio);
        final savedJwt = await DeviceTokenService.getJwt();

        expect((result as DataSuccess<List<String>>).data[0], equals(savedJwt));
      });

      test('data enviada contém deviceToken, appVersion e platform', () async {
        Map<String, dynamic>? capturedData;

        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((invocation) async {
          capturedData =
              invocation.namedArguments[#data] as Map<String, dynamic>;
          return _okResponse({'token': 'jwt'});
        });

        await AuthService.authenticate(dio: mockDio);

        expect(capturedData, isNotNull);
        expect(capturedData!['deviceToken'], isNotEmpty);
        expect(capturedData!['appVersion'], equals('1.0.0'));
        expect(
          capturedData!['platform'],
          anyOf(equals('ANDROID'), equals('IOS')),
        );
      });

      test('deviceToken no DataSuccess é o mesmo enviado na requisição', () async {
        String? sentToken;

        when(mockDio.post(any, data: anyNamed('data')))
            .thenAnswer((invocation) async {
          final data =
              invocation.namedArguments[#data] as Map<String, dynamic>;
          sentToken = data['deviceToken'] as String;
          return _okResponse({'token': 'jwt'});
        });

        final result = await AuthService.authenticate(dio: mockDio);
        final returnedToken = (result as DataSuccess<List<String>>).data[1];

        expect(returnedToken, equals(sentToken));
      });
    });

    group('authenticate() — falhas', () {
      test('retorna NetworkFailure em connectionError', () async {
        when(mockDio.post(any, data: anyNamed('data')))
            .thenThrow(_dioError(DioExceptionType.connectionError));

        final result = await AuthService.authenticate(dio: mockDio);

        expect(result, isA<DataFailed>());
        expect((result as DataFailed).failure, isA<NetworkFailure>());
      });

      test('retorna ServerFailure em badResponse (5xx)', () async {
        when(mockDio.post(any, data: anyNamed('data')))
            .thenThrow(_dioError(
          DioExceptionType.badResponse,
          message: 'Internal Server Error',
        ));

        final result = await AuthService.authenticate(dio: mockDio);

        expect(result, isA<DataFailed>());
        expect((result as DataFailed).failure, isA<ServerFailure>());
      });

      test('mensagem da ServerFailure vem do DioException.message', () async {
        when(mockDio.post(any, data: anyNamed('data')))
            .thenThrow(_dioError(
          DioExceptionType.badResponse,
          message: 'Service unavailable',
        ));

        final result = await AuthService.authenticate(dio: mockDio);

        expect((result as DataFailed).failure.message, equals('Service unavailable'));
      });

      test('retorna ServerFailure com mensagem padrão quando message é null', () async {
        when(mockDio.post(any, data: anyNamed('data')))
            .thenThrow(_dioError(DioExceptionType.badResponse));

        final result = await AuthService.authenticate(dio: mockDio);

        expect((result as DataFailed).failure, isA<ServerFailure>());
        expect((result as DataFailed).failure.message, equals('Falha na autenticação'));
      });

      test('não salva jwt no storage quando falha', () async {
        when(mockDio.post(any, data: anyNamed('data')))
            .thenThrow(_dioError(DioExceptionType.connectionError));

        await AuthService.authenticate(dio: mockDio);

        expect(await DeviceTokenService.getJwt(), isNull);
      });
    });
}
