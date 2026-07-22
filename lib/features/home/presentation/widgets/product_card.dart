import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:no_wait/features/home/domain/entities/shop_it_product.dart';

class ProductCard extends StatelessWidget {
  final ShopItProduct product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedTap(
      onTap: () {},

      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(10.r),
        ),
        width: 165.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 105.h,
                        width: double.infinity,
                        // Product photos ship on a white background, so the
                        // image tile stays light in both themes (matches the
                        // original app).
                        color: AppColors.grey100,
                        child: Center(
                          child: _ProductImage(source: product.imageUrl),
                        ),
                      ),
                      if (product.discountPercent != null)
                        PositionedDirectional(
                          end: 6.w,
                          top: 6.h,
                          child: Container(
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 8.w,
                              vertical: 3.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.discountBadge,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              'home.shop_it.discount_badge'.tr(
                                namedArgs: {
                                  'percent': '${product.discountPercent}',
                                },
                              ),
                              style: AppTextStyles.font10Normal.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColors.grey900,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsetsDirectional.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    color: AppColors.coral.withValues(alpha: 0.25),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            _fulfillmentKey(product.fulfillmentType).tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.font10Normal.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.coral,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          _fulfillmentIcon(product.fulfillmentType),
                          size: 11.r,
                          color: AppColors.coral,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(8.w, 6.h, 8.w, 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.vendorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font10Normal.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font12SemiBold.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Text(
                        _formatPrice(product.currentPrice),
                        style: AppTextStyles.font12SemiBold.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Text(
                            _formatPrice(product.originalPrice!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.font10Normal.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    return 'EGP ${NumberFormat('#,##0', 'en_US').format(price)}';
  }

  IconData _fulfillmentIcon(ProductFulfillmentType type) {
    switch (type) {
      case ProductFulfillmentType.inAppCheckout:
        return Icons.shopping_bag_outlined;
      case ProductFulfillmentType.thirdPartyCheckout:
        return Icons.open_in_new;
    }
  }

  String _fulfillmentKey(ProductFulfillmentType type) {
    switch (type) {
      case ProductFulfillmentType.inAppCheckout:
        return 'home.shop_it.fulfillment.in_app_checkout';
      case ProductFulfillmentType.thirdPartyCheckout:
        return 'home.shop_it.fulfillment.third_party_checkout';
    }
  }
}

/// Renders a local asset for now; transparently swaps to `Image.network`
/// once product images come from the real catalog API (URLs start with
/// `http`), so callers never need to change.
class _ProductImage extends StatelessWidget {
  final String source;

  const _ProductImage({required this.source});

  @override
  Widget build(BuildContext context) {
    if (source.startsWith('http')) {
      return Image.network(source, width: 90.w, fit: BoxFit.contain);
    }
    return Image.asset(source, width: 90.w, fit: BoxFit.contain);
  }
}
