import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/products/domain/entites.dart';

abstract class SearchRepo {
  Future<Either<Failure, List<Product>>> getSearchResult(String query);
}
