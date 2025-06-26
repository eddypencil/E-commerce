import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:e_commerce/features/products/domain/repostries.dart';

class GetProductsUseCase {
  final ProductsRepo productsrepo;

  GetProductsUseCase(this.productsrepo);

  Future<Either<Failure, List<Product>>> call() async {
    return await productsrepo.getProducts();
  }
}

class GetCategoriesUseCase {
  final CategoriesRepo categoriesRepo;

  GetCategoriesUseCase(this.categoriesRepo);

  Future<Either<Failure, List<CategoryEntity>>> call() async {
    return await categoriesRepo.getAllCategories();
  }
}


class GetCategoryItemUseCase {
  final CategoriesItemRepo categoriesItemRepo;

  GetCategoryItemUseCase(this.categoriesItemRepo);

  Future<Either<Failure, List<Product>>> call(CategoryEntity category) async {
    return await categoriesItemRepo.getCategoryItems(category);
  }
}
