import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';
import 'package:no_wait/features/home/presentation/widgets/product_card.dart';

class ShopItSection extends StatelessWidget {
  const ShopItSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              SvgPicture.asset(AppAssets.shopItLogo, height: 22.h),
              const Spacer(),
              AnimatedTap(
                onTap: () {},
                child: Container(
                  padding: EdgeInsetsDirectional.fromSTEB(14.w, 7.h, 10.w, 7.h),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'home.shop_it.explore'.tr(),
                        style: AppTextStyles.font12SemiBold.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      horizontalSpace(2),
                      Icon(
                        Icons.chevron_right,
                        size: 16.r,
                        color: colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        verticalSpace(4),
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
          child: Text(
            'home.shop_it.subtitle'.tr(),
            style: AppTextStyles.font14Normal.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        verticalSpace(14),
        SizedBox(
          height: 170.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
            itemCount: 4,
            separatorBuilder: (_, _) => horizontalSpace(10),
            itemBuilder: (context, index) {
              return ProductCard(discountLabel: index == 1 ? '21%' : null);
            },
          ),
        ),
      ],
    );
  }
}
