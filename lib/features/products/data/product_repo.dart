import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/products/data/data_sources.dart';
import 'package:e_commerce/features/products/data/product_model.dart';
import 'package:e_commerce/features/products/domain/entites.dart';
import 'package:e_commerce/features/products/domain/repostries.dart';
import 'package:e_commerce/features/products/presentation/blocs/Product_cubit.dart';

class ProductsRepoimpl extends ProductsRepo {
  final ProductRemoteDataSource productRemoteDataSource;

  ProductsRepoimpl({required this.productRemoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final productsList = await productRemoteDataSource.getProducts();
      log(productsList.toString());

      return Right(productsList.map(
        (model) {
          return Product(
            id: model.id,
            title: model.title,
            description: model.description,
            category: model.category,
            price: model.price,
            discountPercentage: model.discountPercentage,
            rating: model.rating,
            stock: model.stock,
            tags: model.tags,
            brand: model.brand,
            sku: model.sku,
            weight: model.weight,
            dimensions: Dimensions(
                width: model.dimensions.width,
                height: model.dimensions.height,
                depth: model.dimensions.depth),
            warrantyInformation: model.warrantyInformation,
            shippingInformation: model.shippingInformation,
            availabilityStatus: model.availabilityStatus,
            reviews: model.reviews
                .map(
                  (reviewModel) => Review(
                      comment: reviewModel.comment,
                      date: reviewModel.date,
                      rating: reviewModel.rating,
                      reviewerEmail: reviewModel.reviewerEmail,
                      reviewerName: reviewModel.reviewerName),
                )
                .toList(),
            returnPolicy: model.returnPolicy,
            minimumOrderQuantity: model.minimumOrderQuantity,
            meta: Meta(
                createdAt: model.meta.createdAt,
                updatedAt: model.meta.updatedAt,
                barcode: model.meta.barcode,
                qrCode: model.meta.qrCode),
            images: model.images,
            thumbnail: model.thumbnail,
          );
        },
      ).toList());
    } catch (e) {
      log("$e in repo impl");
      return Left(Failure("Error in ProductsRepoimpl $e"));
    }
  }
}

class CategoriesRepoImp extends CategoriesRepo {
  final CategoriesRemoteDataSource categoriesRemoteDataSource;

  CategoriesRepoImp({required this.categoriesRemoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getAllCategories() async {
    try {
      final categoryList = await categoriesRemoteDataSource.getAllCategories();
      final categoryEntityList = categoryList
          .map((categoryModel) => CategoryEntity(
                slug: categoryModel.slug,
                name: categoryModel.name,
                url: categoryModel.url,
              ))
          .toList();

      return Right(categoryEntityList);
    } catch (e) {
      log("${e}at cate repo impl");
      return Left(Failure("Error in CategoryRepoimpl $e"));
    }
  }
}

class CategoriesItemRepoImp extends CategoriesItemRepo {
  final CategoriesItemsRemoteDataSource categoriesItemsRemoteDataSource;

  CategoriesItemRepoImp({required this.categoriesItemsRemoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getCategoryItems(
      CategoryEntity category) async {
    try {
      final categoryItems =
          await categoriesItemsRemoteDataSource.getCategoryItems(category);
      final categoryItemsEntityList = categoryItems
          .map((productModel) => Product(
                id: productModel.id,
                title: productModel.title,
                description: productModel.description,
                category: productModel.category,
                price: productModel.price,
                discountPercentage: productModel.discountPercentage,
                rating: productModel.rating,
                stock: productModel.stock,
                tags: productModel.tags,
                brand: productModel.brand,
                sku: productModel.sku,
                weight: productModel.weight,
                dimensions: Dimensions(
                    width: productModel.dimensions.width,
                    height: productModel.dimensions.height,
                    depth: productModel.dimensions.depth),
                warrantyInformation: productModel.warrantyInformation,
                shippingInformation: productModel.shippingInformation,
                availabilityStatus: productModel.availabilityStatus,
                reviews: productModel.reviews
                    .map(
                      (review) => Review(
                          rating: review.rating,
                          comment: review.comment,
                          date: review.date,
                          reviewerName: review.reviewerName,
                          reviewerEmail: review.reviewerEmail),
                    )
                    .toList(),
                returnPolicy: productModel.returnPolicy,
                minimumOrderQuantity: productModel.minimumOrderQuantity,
                meta: Meta(
                    createdAt: productModel.meta.createdAt,
                    updatedAt: productModel.meta.updatedAt,
                    barcode: productModel.meta.barcode,
                    qrCode: productModel.meta.qrCode),
                images: productModel.images,
                thumbnail: productModel.thumbnail,
              ))
          .toList();

      return Right(categoryItemsEntityList);
    } catch (e) {
      log("${e}at cate repo impl");
      return Left(Failure("Error in CategoryRepoimpl $e"));
    }
  }
}
