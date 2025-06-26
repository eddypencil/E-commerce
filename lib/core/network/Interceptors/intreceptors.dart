import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/ApiConsumers/dio_consumer.dart';
import 'package:e_commerce/core/injection/get_It.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Logs all requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler,) {
    // log('➡️ ${options.method} ${options.uri}');
    // log('Headers: ${options.headers}');
    // if (options.data != null) log('Body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response,
      ResponseInterceptorHandler handler,) {
    // log('✅ ${response.statusCode} ${response.realUri}');
    // log('Response: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err,
      ErrorInterceptorHandler handler,) {
    // log('⛔️ ${err.response?.statusCode} ${err.requestOptions.uri}');
    // log('Error message: ${err.message}');
    handler.next(err);
  }
}

/// Adds default headers like Content-Type
class AuthInterceptor extends Interceptor {
  final storage = getIt<FlutterSecureStorage>();
  final Dio dio;

  AuthInterceptor({required this.dio});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      options.headers['Content-Type'] = 'application/json';

      // Use accessToken from secure storage instead of request body
      final accessToken = await storage.read(key: 'accessToken');

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (e, stackTrace) {
      log('Error in AuthInterceptor.onRequest: $e');
      log('$stackTrace');
      handler.next(options); // Proceed anyway to avoid breaking requests
    }
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 403) {
      try {
        String? refreshToken = await storage.read(key: 'refreshToken');

        if (refreshToken == null) {
          handler.next(err);
          return;
        }

        final refreshRes = await DioConsumer(dio: dio).post(
          url: 'https://dummyjson.com/auth/refresh',
          data: {
            "refreshToken": refreshToken,
            "expiresInMins": 30,
          },
        );

        final newAccess = refreshRes.data['accessToken'] as String;
        final newRefresh = refreshRes.data['refreshToken'] as String;

        await storage.write(key: 'accessToken', value: newAccess);
        await storage.write(key: 'refreshToken', value: newRefresh);

        // Retry the original request with new access token
        final clonedRequest = await _retryRequest(err.requestOptions, newAccess);
        handler.resolve(clonedRequest);
      } catch (e) {
        log('Token refresh failed: $e');
        handler.next(err); // Let the error propagate
      }
    } else {
      handler.next(err);
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions, String newAccessToken) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newAccessToken',
      },
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}




