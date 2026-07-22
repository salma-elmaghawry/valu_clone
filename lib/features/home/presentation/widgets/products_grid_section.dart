import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:no_wait/features/home/domain/entities/quick_access_service.dart';

class ProductsGridSection extends StatelessWidget {
  final List<QuickAccessService> services;

  const ProductsGridSection({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home.products.title'.tr(),
          style: AppTextStyles.font16Normal.copyWith(
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
          ),
        ),
        verticalSpace(14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 18.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            return _QuickAccessTile(
              service: services[index],
            ).fadeInScale(delay: AppAnimations.gridStaggerDelay * index);
          },
        ),
      ],
    );
  }
}

class _QuickAccessTile extends StatelessWidget {
  final QuickAccessService service;

  const _QuickAccessTile({required this.service});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final logoAsset = _logoFor(service.type);

    return AnimatedTap(
      onTap: () {},
      child: Container(
        padding: EdgeInsetsDirectional.all(10.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 22.h,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: _ServiceLogo(source: logoAsset),
              ),
            ),
            verticalSpace(6),
            Text(
              service.descriptionKey.tr(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font10Normal.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _logoFor(QuickAccessServiceType type) {
    switch (type) {
      case QuickAccessServiceType.prepaidCard:
        return AppAssets.prepaidCardLogo;
      case QuickAccessServiceType.cashAdvance:
        return AppAssets.cashAdvanceLogo;
      case QuickAccessServiceType.autoFinance:
        return AppAssets.autoFinanceLogo;
      case QuickAccessServiceType.sendMoney:
        return AppAssets.sendMoneyLogo;
      case QuickAccessServiceType.invest:
        return AppAssets.investLogo;
      case QuickAccessServiceType.business:
        return AppAssets.businessLogo;
    }
  }
}

class _ServiceLogo extends StatelessWidget {
  final String source;

  const _ServiceLogo({required this.source});

  @override
  Widget build(BuildContext context) {
    if (source.endsWith('.svg')) {
      return SvgPicture.asset(source, height: 22.h, fit: BoxFit.contain);
    }
    return Image.asset(source, height: 22.h, fit: BoxFit.contain);
  }
}
