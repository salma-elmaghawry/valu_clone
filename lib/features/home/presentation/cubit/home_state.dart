import 'package:no_wait/core/bloc/base_bloc.dart';
import 'package:no_wait/core/error_handling/failures.dart';
import 'package:no_wait/features/home/domain/entities/account_limit_status.dart';
import 'package:no_wait/features/home/domain/entities/quick_access_service.dart';
import 'package:no_wait/features/home/domain/entities/shop_it_product.dart';

enum HomeAction { fetchSummary }

class HomeState extends BaseState {
  final AccountLimitStatus accountStatus;
  final List<ShopItProduct> shopItProducts;
  final List<QuickAccessService> quickAccessServices;
  final Failure? failure;
  final HomeAction? action;

  const HomeState({
    super.status = Status.initial,
    super.message,
    this.accountStatus = AccountLimitStatus.active,
    this.shopItProducts = const [],
    this.quickAccessServices = const [],
    this.failure,
    this.action,
  });

  HomeState copyWith({
    Status? status,
    String? message,
    AccountLimitStatus? accountStatus,
    List<ShopItProduct>? shopItProducts,
    List<QuickAccessService>? quickAccessServices,
    Failure? failure,
    HomeAction? action,
  }) {
    return HomeState(
      status: status ?? this.status,
      message: message ?? this.message,
      accountStatus: accountStatus ?? this.accountStatus,
      shopItProducts: shopItProducts ?? this.shopItProducts,
      quickAccessServices: quickAccessServices ?? this.quickAccessServices,
      failure: failure ?? this.failure,
      action: action ?? this.action,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    accountStatus,
    shopItProducts,
    quickAccessServices,
    failure,
    action,
  ];
}
