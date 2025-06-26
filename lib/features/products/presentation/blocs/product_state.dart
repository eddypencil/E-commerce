import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:equatable/equatable.dart';

sealed class ProductState extends Equatable {}

class ProductsInitial extends ProductState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductsLoading extends ProductState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ProductsLoaded extends ProductState {
  final List<Product> productsList;
  final List<CategoryEntity> categoryEntityList;

  ProductsLoaded(
      {required this.categoryEntityList, required this.productsList});

  ProductsLoaded copyWith({
    List<Product>? productsList,
    List<CategoryEntity>? categoryEntityList,
  }) {
    return ProductsLoaded(
        categoryEntityList: categoryEntityList ?? this.categoryEntityList,
        productsList: productsList ?? this.productsList);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [productsList, categoryEntityList];
}

class ProductsError extends ProductState {
  final String error;

  ProductsError({required this.error});

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class CategoryItemsLoading extends ProductState {
  final List<CategoryEntity> categoryEntityList;
  final List<Product> productsList;

  CategoryItemsLoading(
      {required this.productsList, required this.categoryEntityList});

  @override
  List<Object?> get props => [categoryEntityList, productsList];
}
