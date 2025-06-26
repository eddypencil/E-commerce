import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/ApiConsumers/dio_consumer.dart';
import 'package:e_commerce/core/network/end_points.dart';
import 'package:e_commerce/features/auth/data/Model.dart';
import 'package:e_commerce/core/injection/get_It.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthenticationRemoteDataSource {
  Future<UserModel> loginUser(Map<String, dynamic> data);
  Future<UserModel> checkIfloginUser(Map<String, dynamic> data);
}

class AuthenticationRemoteDataSourceImpl
    extends AuthenticationRemoteDataSource {
  final Dio dio;
  final storage = getIt<FlutterSecureStorage>();
  AuthenticationRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> loginUser(Map<String, dynamic> data) async {
    try {
      final response = await DioConsumer(dio: dio)
          .post(url: EndPoints.usernamePasswordLogin , data: data);

      log("✅ DataSource: user data received: $response");

      final accessToken = response['accessToken'];
      final refreshToken = response['refreshToken'];

      await storage.write(key: 'accessToken', value: accessToken);
      await storage.write(key: 'refreshToken', value: refreshToken);

      return UserModel.fromJson(response);
    } catch (e) {
      log("❌ Unknown error in loginUser", error: e);
      rethrow;
    }
  }
  @override
  Future<UserModel> checkIfloginUser(Map<String, dynamic> data) async {
    try {
      final response = await DioConsumer(dio: dio)
          .get(url: EndPoints.tokenLogin , options: Options(headers: data) );

      log("✅ DataSource: user data received with token: $response");

      
      return UserModel.fromJson(response);
    } catch (e) {
      log("❌ Unknown error in loginUser with token", error: e);
      rethrow;
    }
  }
}
