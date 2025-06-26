class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final DimensionsModel dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ReviewModel> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final MetaModel meta;
  final List<String> images;
  final String thumbnail;
  bool isFavorite;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  }):isFavorite= true;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      discountPercentage: (json['discountPercentage'] as num? ?? 0).toDouble(),
      rating: (json['rating'] as num? ?? 0).toDouble(),
      stock: json['stock'] as int? ?? 0,
      tags: List<String>.from(json['tags'] as List? ?? []),
      brand: json['brand'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      weight: json['weight'] as int? ?? 0,
      dimensions: DimensionsModel.fromJson(json['dimensions'] as Map<String, dynamic>? ?? {}),
      warrantyInformation: json['warrantyInformation'] as String? ?? '',
      shippingInformation: json['shippingInformation'] as String? ?? '',
      availabilityStatus: json['availabilityStatus'] as String? ?? '',
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>? ?? {}))
          .toList(),
      returnPolicy: json['returnPolicy'] as String? ?? '',
      minimumOrderQuantity: json['minimumOrderQuantity'] as int? ?? 0,
      meta: MetaModel.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
      images: List<String>.from(json['images'] as List? ?? []),
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'discountPercentage': discountPercentage,
      'rating': rating,
      'stock': stock,
      'tags': tags,
      'brand': brand,
      'sku': sku,
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
      'availabilityStatus': availabilityStatus,
      'reviews': reviews.map((r) => r.toJson()).toList(),
      'returnPolicy': returnPolicy,
      'minimumOrderQuantity': minimumOrderQuantity,
      'meta': meta.toJson(),
      'images': images,
      'thumbnail': thumbnail,
    };
  }
}

class DimensionsModel {
  final double width;
  final double height;
  final double depth;

  const DimensionsModel({
    required this.width,
    required this.height,
    required this.depth,
  });

  factory DimensionsModel.fromJson(Map<String, dynamic> json) {
    return DimensionsModel(
      width: (json['width'] as num? ?? 0).toDouble(),
      height: (json['height'] as num? ?? 0).toDouble(),
      depth: (json['depth'] as num? ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'width': width,
      'height': height,
      'depth': depth,
    };
  }
}

class ReviewModel {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  ReviewModel({
    required this.rating,
    required this.comment,
    required DateTime date,
    required this.reviewerName,
    required this.reviewerEmail,
  }) : date = date;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      rating: json['rating'] as int? ?? 0,
      comment: json['comment'] as String? ?? '',
      date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.fromMillisecondsSinceEpoch(0),
      reviewerName: json['reviewerName'] as String? ?? '',
      reviewerEmail: json['reviewerEmail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'reviewerName': reviewerName,
      'reviewerEmail': reviewerEmail,
    };
  }
}

class MetaModel {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  MetaModel({
    required DateTime createdAt,
    required DateTime updatedAt,
    required this.barcode,
    required this.qrCode,
  })  : createdAt = createdAt,
        updatedAt = updatedAt;

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.fromMillisecondsSinceEpoch(0),
      barcode: json['barcode'] as String? ?? '',
      qrCode: json['qrCode'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'barcode': barcode,
      'qrCode': qrCode,
    };
  }
}
