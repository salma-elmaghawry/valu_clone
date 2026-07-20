import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/theme/controller/theme_cubit.dart';
import 'package:no_wait/core/theme/controller/theme_state.dart';
import 'package:no_wait/core/utils/app_assets.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Image.asset(AppAssets.logo, height: 26.h),
        const Spacer(),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final isDark = _isDark(context, themeState.themeMode);
            return AnimatedTap(
              onTap: () => context.read<ThemeCubit>().setThemeMode(
                isDark ? ThemeMode.light : ThemeMode.dark,
              ),
              child: Icon(
                isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                size: 22.r,
                color: colorScheme.onSurface,
              ),
            );
          },
        ),
        SizedBox(width: 16.w),
        AnimatedTap(
          onTap: () {},
          child: SvgPicture.asset(
            AppAssets.notification,
            height: 22.r,
            colorFilter: ColorFilter.mode(
              colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  bool _isDark(BuildContext context, ThemeMode mode) {
    if (mode == ThemeMode.dark) return true;
    if (mode == ThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }
}
