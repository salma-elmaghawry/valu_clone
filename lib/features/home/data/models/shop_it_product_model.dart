import 'package:no_wait/features/home/domain/entities/shop_it_product.dart';

class ShopItProductModel {
  final String id;
  final String imageUrl;
  final String vendorName;
  final String title;
  final double currentPrice;
  final double? originalPrice;
  final int? discountPercent;
  final String fulfillmentType;

  const ShopItProductModel({
    required this.id,
    required this.imageUrl,
    required this.vendorName,
    required this.title,
    required this.currentPrice,
    this.originalPrice,
    this.discountPercent,
    required this.fulfillmentType,
  });

  factory ShopItProductModel.fromJson(Map<String, dynamic> json) {
    return ShopItProductModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      vendorName: json['vendorName'] as String,
      title: json['title'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      discountPercent: json['discountPercent'] as int?,
      fulfillmentType: json['fulfillmentType'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'vendorName': vendorName,
    'title': title,
    'currentPrice': currentPrice,
    'originalPrice': originalPrice,
    'discountPercent': discountPercent,
    'fulfillmentType': fulfillmentType,
  };

  ShopItProduct toEntity() => ShopItProduct(
    id: id,
    imageUrl: imageUrl,
    vendorName: vendorName,
    title: title,
    currentPrice: currentPrice,
    originalPrice: originalPrice,
    discountPercent: discountPercent,
    fulfillmentType: ProductFulfillmentType.values.firstWhere(
      (t) => t.name == fulfillmentType,
      orElse: () => ProductFulfillmentType.inAppCheckout,
    ),
  );
}
