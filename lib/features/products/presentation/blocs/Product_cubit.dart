import 'dart:developer';

import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:e_commerce/features/products/domain/usecases.dart';
import 'package:e_commerce/features/products/presentation/blocs/product_state.dart';
import 'package:e_commerce/core/injection/get_It.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;
  final GetCategoryItemUseCase _getCategoryItem;

  ProductCubit()
      : _getProducts = getIt<GetProductsUseCase>(),
        _getCategories = getIt<GetCategoriesUseCase>(),
        _getCategoryItem = getIt<GetCategoryItemUseCase>(),
        super(ProductsInitial());

  void getProducts() async {
    emit(ProductsLoading());
    final productsResult = await _getProducts();
    final categoriesResult = await _getCategories();
    log("results in cubit are $productsResult");
    productsResult.fold(
      (failure) {
        emit(ProductsError(error: failure.error));
      },
      (products) {
        categoriesResult.fold(
          (failure) {
            emit(ProductsError(error: failure.error));
          },
          (categories) {
            log("Loaded ${products.length} products and ${categories.length} categories");
            emit(ProductsLoaded(
                categoryEntityList: categories, productsList: products));
          },
        );
      },
    );
  }

  void getCategoryItems(CategoryEntity category) async {
    
    if (state is ProductsLoaded) {
      final previous = state as ProductsLoaded;

      emit(CategoryItemsLoading(
        productsList: previous.productsList,
        categoryEntityList: previous.categoryEntityList,
      ));
      log('getCategoryItems used in cubit');

      final result = await _getCategoryItem(category);
      result.fold(
        (fail) => emit(ProductsError(error: fail.error)),
        (items) => emit(
          // use the stored 'previous' (still has categories) to copy from
          previous.copyWith(productsList: items),
        ),
      );
    }
  }
}
