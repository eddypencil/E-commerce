import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/ApiConsumers/api_consumer.dart';
import 'package:e_commerce/core/network/Exceptions/exceptions.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio});

  @override
  Future<dynamic> get({
    String? url,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        url!,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      log("Unexpected error in DioConsumer.get: $e");
      throw Exception("Unexpected error occurred");
    }
  }

  @override
  Future<dynamic> post({
    String? url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        url!,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      log("Unexpected error in DioConsumer.post: $e");
      throw Exception("Unexpected error occurred");
    }
  }

  @override
  Future<dynamic> patch({
    String? url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await dio.patch(
        url!,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      log("Unexpected error in DioConsumer.patch: $e");
      throw Exception("Unexpected error occurred");
    }
  }

  @override
  Future<dynamic> delete({
    String? url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        url!,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    } catch (e) {
      log("Unexpected error in DioConsumer.delete: $e");
      throw Exception("Unexpected error occurred");
    }
  }
}

void _handleDioException(DioException e) {
  log("DioException in DioConsumer: ${e.message}, Response: ${e.response?.data}");
  final statusCode = e.response?.statusCode;
  final errorMessage = e.response?.data?['message'] ?? e.message ?? 'Unknown network error';

  switch (statusCode) {
    case 400:
      throw BadRequestException(errorMessage);
    case 401:
      throw UnauthorizedException("Invalid username or password");
    case 404:
      throw NotFoundException("Resource not found");
    case 500:
    case 502:
    case 503:
      throw ServerErrorException("Server error, please try again later");
    default:
      throw Exception("Network error: $errorMessage");
  }
}
