import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

class ProductCard extends StatelessWidget {
  final String? discountLabel;

  const ProductCard({super.key, this.discountLabel});

  @override
  Widget build(BuildContext context) {
    return AnimatedTap(
      onTap: () {},
      child: Container(
        width: 150.w,
        decoration: BoxDecoration(
          // Product photos ship on a white background, so the card stays
          // light in both themes (matches the original app).
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Stack(
          children: [
            Center(child: Image.asset(AppAssets.product, width: 100.w)),
            if (discountLabel != null)
              PositionedDirectional(
                end: 0,
                top: 12.h,
                child: Container(
                  padding: EdgeInsetsDirectional.fromSTEB(10.w, 3.h, 8.w, 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.discountBadge,
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(10.r),
                      bottomStart: Radius.circular(10.r),
                    ),
                  ),
                  child: Text(
                    discountLabel!,
                    style: AppTextStyles.font12SemiBold.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.grey900,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
