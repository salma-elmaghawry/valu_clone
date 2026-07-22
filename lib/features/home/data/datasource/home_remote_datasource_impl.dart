import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/features/home/data/datasource/home_remote_datasource.dart';
import 'package:no_wait/features/home/data/models/home_summary_model.dart';

/// In-memory demo backend until the real API is ready.
/// Returns data already shaped like the future REST response, so swapping
/// this class for a Dio-backed implementation only touches this file —
/// callers only ever see [HomeSummaryModel].
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  static const _latency = Duration(milliseconds: 700);

  @override
  Future<HomeSummaryModel> getHomeSummary() async {
    await Future.delayed(_latency);
    return HomeSummaryModel.fromJson(_mockResponse);
  }

  static final Map<String, dynamic> _mockResponse = {
    'accountStatus': 'blocked',
    'shopItProducts': [
      {
        'id': 'p-1',
        'imageUrl': AppAssets.product,
        'vendorName': 'Dubai Phone',
        'title': 'Xiaomi Smart Air Fryer 5.5L',
        'currentPrice': 6999,
        'originalPrice': 8490,
        'discountPercent': 18,
        'fulfillmentType': 'thirdPartyCheckout',
      },
      {
        'id': 'p-2',
        'imageUrl': AppAssets.product,
        'vendorName': 'Samsung',
        'title': 'Samsung Galaxy A56 5G',
        'currentPrice': 22490,
        'originalPrice': 26499,
        'discountPercent': 15,
        'fulfillmentType': 'inAppCheckout',
      },
      {
        'id': 'p-3',
        'imageUrl': AppAssets.product,
        'vendorName': 'No Wait Marketplace',
        'title': 'Everyday Essentials Bundle',
        'currentPrice': 1299,
        'fulfillmentType': 'inAppCheckout',
      },
    ],
    'quickAccessServices': [
      {
        'type': 'prepaidCard',
        'titleKey': 'home.products.prepaid_card.title',
        'descriptionKey': 'home.products.prepaid_card.description',
      },
      {
        'type': 'cashAdvance',
        'titleKey': 'home.products.cash_advance.title',
        'descriptionKey': 'home.products.cash_advance.description',
      },
      {
        'type': 'autoFinance',
        'titleKey': 'home.products.auto_finance.title',
        'descriptionKey': 'home.products.auto_finance.description',
      },
      {
        'type': 'sendMoney',
        'titleKey': 'home.products.send_money.title',
        'descriptionKey': 'home.products.send_money.description',
      },
      {
        'type': 'invest',
        'titleKey': 'home.products.invest.title',
        'descriptionKey': 'home.products.invest.description',
      },
      {
        'type': 'business',
        'titleKey': 'home.products.business.title',
        'descriptionKey': 'home.products.business.description',
      },
    ],
  };
}
