import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/Search/domain/repo/Search_repo.dart';
import 'package:e_commerce/features/products/domain/entites.dart';

class GetSearchResultUseCase {
  final SearchRepo searchRepo;

  GetSearchResultUseCase({required this.searchRepo});

  

  Future<Either<Failure, List<Product>>> call(String query) async {
    return await searchRepo.getSearchResult(query);
  }
}