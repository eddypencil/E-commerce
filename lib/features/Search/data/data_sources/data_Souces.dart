import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/ApiConsumers/dio_consumer.dart';
import 'package:e_commerce/core/network/end_points.dart';
import 'package:e_commerce/features/auth/data/Model.dart';
import 'package:e_commerce/features/products/data/product_model.dart';
import 'package:e_commerce/core/injection/get_It.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SearchRemoteDataSource {
  Future<List<ProductModel>> getSearchResult(String query);
  
}

class SearchRemoteDataSourceImpl
    extends SearchRemoteDataSource {
  final Dio dio;
  final storage = getIt<FlutterSecureStorage>();
  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getSearchResult(String query) async {
    try {
      final response = await DioConsumer(dio: dio)
          .get(url: EndPoints.searchEndpoint, queryParameters: {'q': query});

      log("✅ Search DataSource: user data received: $response");


        final List<dynamic> productsJson = response['products'];
      final List<ProductModel> products = productsJson
          .map((json) => ProductModel.fromJson(json))
          .toList();

      return products;
    } catch (e) {
      log("❌ Unknown error in loginUser", error: e);
      rethrow;
    }
  }
  
}
