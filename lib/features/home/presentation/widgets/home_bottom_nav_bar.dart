import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/theme/app_colors.dart';
import 'package:no_wait/core/utils/app_assets.dart';
import 'package:no_wait/core/utils/app_text_styles.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(12.w, 0, 12.w, 12.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 55.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.grey400.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          _NavItem(
            index: 0,
            currentIndex: currentIndex,
            onTap: onTap,
            label: 'home.nav.home'.tr(),
            iconBuilder:(color) => SvgPicture.asset(
              AppAssets.navHome,
              height: 22.r,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          _NavItem(
            index: 1,
            currentIndex: currentIndex,
            onTap: onTap,
            label: 'home.nav.stores'.tr(),
            iconBuilder: (color) => SizedBox(
              height: 22.r,
              child: Image.asset(
                AppAssets.logoMark,
                width: 24.w,
                color: color,
                fit: BoxFit.contain,
              ),
            ),
          ),
          _NavItem(
            index: 2,
            currentIndex: currentIndex,
            onTap: onTap,
            label: 'home.nav.shop_it'.tr(),
            iconBuilder: (color) => SvgPicture.asset(
              AppAssets.navStores,
              height: 22.r,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          _NavItem(
            index: 3,
            currentIndex: currentIndex,
            onTap: onTap,
            label: 'home.nav.profile'.tr(),
            iconBuilder: (color) => SvgPicture.asset(
              AppAssets.navProfile,
              height: 22.r,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
          _NavItem(
            index: 4,
            currentIndex: currentIndex,
            onTap: onTap,
            label: 'home.nav.menu'.tr(),
            iconBuilder: (color) => SvgPicture.asset(
              AppAssets.navMenu,
              height: 22.r,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final String label;
  final Widget Function(Color color) iconBuilder;

  const _NavItem({
    required this.index,
    required this.currentIndex,
    required this.onTap,
    required this.label,
    required this.iconBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = index == currentIndex;
    final color = isSelected ? AppColors.primary : colorScheme.onSurfaceVariant;

    return Expanded(
      child: AnimatedTap(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconBuilder(color),
            SizedBox(height: 4.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font10Normal.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
