import 'package:no_wait/features/home/data/models/quick_access_service_model.dart';
import 'package:no_wait/features/home/data/models/shop_it_product_model.dart';
import 'package:no_wait/features/home/domain/entities/account_limit_status.dart';
import 'package:no_wait/features/home/domain/entities/home_summary.dart';

class HomeSummaryModel {
  final String accountStatus;
  final List<ShopItProductModel> shopItProducts;
  final List<QuickAccessServiceModel> quickAccessServices;

  const HomeSummaryModel({
    required this.accountStatus,
    required this.shopItProducts,
    required this.quickAccessServices,
  });

  factory HomeSummaryModel.fromJson(Map<String, dynamic> json) {
    return HomeSummaryModel(
      accountStatus: json['accountStatus'] as String,
      shopItProducts: (json['shopItProducts'] as List)
          .map((e) => ShopItProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      quickAccessServices: (json['quickAccessServices'] as List)
          .map((e) => QuickAccessServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  HomeSummary toEntity() => HomeSummary(
    accountStatus: AccountLimitStatus.values.firstWhere(
      (s) => s.name == accountStatus,
      orElse: () => AccountLimitStatus.active,
    ),
    shopItProducts: shopItProducts.map((e) => e.toEntity()).toList(),
    quickAccessServices: quickAccessServices.map((e) => e.toEntity()).toList(),
  );
}
