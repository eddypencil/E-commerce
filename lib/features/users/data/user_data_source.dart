import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/ApiConsumers/dio_consumer.dart';
import 'package:e_commerce/core/network/end_points.dart';
import 'package:e_commerce/features/auth/data/Model.dart';
import 'package:e_commerce/core/injection/get_It.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser();
}

class UserRemoteDataSourceImp implements UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSourceImp(this.dio);

  @override
  Future<UserModel> getUser() async {
    try {
  
      final storage = getIt<FlutterSecureStorage>();
      final accessToken = await storage.read(key: 'accessToken');

      
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception("Access token is missing.");
      }

      
      final response = await DioConsumer(dio: dio).get(
        url: EndPoints.Users,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      final data=response;
      return UserModel.fromJson(data);
    } catch (e) {
      log("error in UserRemoteDataSourceImp: $e");
      throw Exception(e.toString());
    }
  }
}
