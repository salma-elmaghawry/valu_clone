import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({super.key});

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  static const int _bannersCount = 3;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.94);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _bannersCount,

            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 5.w),
                child: switch (index) {
                  0 => const _BrandBanner(color: AppColors.darkTeal),
                  1 => const _TicketsMarcheBanner(),
                  _ => const _BrandBanner(color: AppColors.third),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TicketsMarcheBanner extends StatelessWidget {
  const _TicketsMarcheBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFB03A), Color(0xFFFF7A1A)],
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsetsDirectional.only(top: 10.h),
              child: Text(
                'home.banner.title'.tr(),
                style: AppTextStyles.font14SemiBold.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: 16.w,
            top: 28.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'home.banner.visit'.tr(),
                  style: AppTextStyles.font14SemiBold.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'home.banner.url'.tr(),
                  style: AppTextStyles.font12SemiBold.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
                Text(
                  'home.banner.enjoy'.tr(),
                  style: AppTextStyles.font10Normal.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'home.banner.percent'.tr(),
                  style: AppTextStyles.font32Bold.copyWith(
                    fontSize: 30.sp,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'home.banner.moneyback'.tr(),
                    style: AppTextStyles.font12SemiBold.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: ' ${'home.banner.with'.tr()}',
                        style: AppTextStyles.font10Normal.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'home.banner.card'.tr(),
                  style: AppTextStyles.font10Normal.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          PositionedDirectional(
            end: 30.w,
            top: 30.h,
            child: Transform.rotate(
              angle: 0.12,
              child: Container(
                width: 62.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.grey800, width: 2),
                ),
                padding: EdgeInsets.all(4.r),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7.r),
                  child: ColoredBox(
                    color: AppColors.grey900,
                    child: Center(
                      child: Image.asset(
                        AppAssets.logoMark,
                        width: 34.w,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsetsDirectional.only(bottom: 4.h),
              child: Text(
                'home.banner.terms'.tr(),
                style: AppTextStyles.font10Normal.copyWith(
                  fontSize: 7.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandBanner extends StatelessWidget {
  final Color color;

  const _BrandBanner({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Image.asset(AppAssets.logoMark, width: 90.w),
      ),
    );
  }
}
