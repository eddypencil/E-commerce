import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:e_commerce/core/network/ApiConsumers/dio_consumer.dart';
import 'package:e_commerce/core/network/end_points.dart';

import 'package:e_commerce/features/products/data/product_model.dart';
import 'package:e_commerce/features/products/domain/entites.dart';

import 'category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

abstract class CategoriesRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
}

abstract class CategoriesItemsRemoteDataSource {
  Future<List<ProductModel>> getCategoryItems(CategoryEntity category);
}

class ProductRemoteDataSourceImp implements ProductRemoteDataSource {
  final Dio dio;
  ProductRemoteDataSourceImp(this.dio);

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final data = await DioConsumer(dio: dio).get(url: EndPoints.allProducts);
      final productList = data['products'] as List;
      return productList
          .map(
            (product) => ProductModel.fromJson(product),
          )
          .toList();
    } catch (e) {
      log("error in ProductRemoteDataSourceImp");
      throw Exception(e.toString());
    }
  }
}

class CategoriesRemoteDataSourceImp implements CategoriesRemoteDataSource {
  final Dio dio;
  CategoriesRemoteDataSourceImp(this.dio);
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final data =
          await DioConsumer(dio: dio).get(url: EndPoints.allCategories);
      final categoriesList = data as List;
      return categoriesList
          .map((category) => CategoryModel.fromjson(category))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class CategoriesItemsRemoteDataSourceImp
    extends CategoriesItemsRemoteDataSource {
  final Dio dio;

  CategoriesItemsRemoteDataSourceImp({required this.dio});

  @override
  Future<List<ProductModel>> getCategoryItems(CategoryEntity category) async {
    try {
      final data = await DioConsumer(dio: dio).get(url: category.url);
      final categorieItemList = data['products'] as List;
      return categorieItemList
          .map((categoryItem) => ProductModel.fromJson(categoryItem))
          .toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
