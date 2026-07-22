import 'package:equatable/equatable.dart';
import 'package:no_wait/features/home/domain/entities/account_limit_status.dart';
import 'package:no_wait/features/home/domain/entities/quick_access_service.dart';
import 'package:no_wait/features/home/domain/entities/shop_it_product.dart';

/// Everything the home screen needs, bundled into one call so the screen
/// has a single loading/error state instead of juggling three requests.
class HomeSummary extends Equatable {
  final AccountLimitStatus accountStatus;
  final List<ShopItProduct> shopItProducts;
  final List<QuickAccessService> quickAccessServices;

  const HomeSummary({
    required this.accountStatus,
    required this.shopItProducts,
    required this.quickAccessServices,
  });

  @override
  List<Object?> get props => [accountStatus, shopItProducts, quickAccessServices];
}
