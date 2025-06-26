 import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/products/domain/entites.dart';


abstract class ProductsRepo{
  Future<Either<Failure,List<Product>>> getProducts();
}

abstract class CategoriesRepo{
Future<Either<Failure,List<CategoryEntity>>>getAllCategories();
}

abstract class CategoriesItemRepo{
  Future<Either<Failure,List<Product>>>getCategoryItems(CategoryEntity category);
}