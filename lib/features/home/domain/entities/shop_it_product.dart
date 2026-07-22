import 'package:equatable/equatable.dart';

enum ProductFulfillmentType { inAppCheckout, thirdPartyCheckout }

class ShopItProduct extends Equatable {
  final String id;

  /// Local asset path for now; will hold a network URL once the catalog
  /// API is wired up (the widget layer already handles both).
  final String imageUrl;
  final String vendorName;
  final String title;
  final double currentPrice;
  final double? originalPrice;
  final int? discountPercent;
  final ProductFulfillmentType fulfillmentType;

  const ShopItProduct({
    required this.id,
    required this.imageUrl,
    required this.vendorName,
    required this.title,
    required this.currentPrice,
    this.originalPrice,
    this.discountPercent,
    required this.fulfillmentType,
  });

  @override
  List<Object?> get props => [
    id,
    imageUrl,
    vendorName,
    title,
    currentPrice,
    originalPrice,
    discountPercent,
    fulfillmentType,
  ];
}
