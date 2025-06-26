import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/Search/data/data_sources/data_Souces.dart';
import 'package:e_commerce/features/Search/domain/repo/Search_repo.dart';
import 'package:e_commerce/features/products/domain/entites.dart';

class SearchRepoImpl extends SearchRepo {
  final SearchRemoteDataSource searchRemoteDataSource;

  SearchRepoImpl({required this.searchRemoteDataSource});
  @override
  Future<Either<Failure, List<Product>>> getSearchResult(String query) async {
    try {
      final productsList = await searchRemoteDataSource.getSearchResult(query);
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
