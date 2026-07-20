import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/features/home/presentation/widgets/bnpl_section.dart';
import 'package:no_wait/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:no_wait/features/home/presentation/widgets/home_header.dart';
import 'package:no_wait/features/home/presentation/widgets/promo_banner_carousel.dart';
import 'package:no_wait/features/home/presentation/widgets/registration_progress_card.dart';
import 'package:no_wait/features/home/presentation/widgets/shop_it_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final sidePadding = EdgeInsetsDirectional.symmetric(horizontal: 16.w);
    final background = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        padding: EdgeInsetsDirectional.only(top: 28.h),
        decoration: BoxDecoration(
          // Fades the content scrolling underneath the floating nav bar
          // into the background so it reads as dimmed, like the real app.
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              background.withValues(alpha: 0),
              background.withValues(alpha: 0.85),
              background,
            ],
            stops: const [0, 0.4, 0.75],
          ),
        ),
        child: SafeArea(
          top: false,
          child: HomeBottomNavBar(
            currentIndex: _currentTab,
            onTap: (index) => setState(() => _currentTab = index),
          ),
        ),
      ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 4),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.only(top: 8.h, bottom: 96.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: sidePadding,
                child: const HomeHeader(),
              ).fadeInSlideUp(),
              verticalSpace(16),
              Padding(
                padding: sidePadding,
                child: const RegistrationProgressCard(),
              ).fadeInSlideUp(delay: AppAnimations.sectionDelay),
              verticalSpace(16),
              const PromoBannerCarousel().fadeInSlideUp(
                delay: AppAnimations.sectionDelay * 2,
              ),
              verticalSpace(16),
              Padding(
                padding: sidePadding,
                child: const BnplSection(),
              ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 3),
              verticalSpace(20),
              const ShopItSection().fadeInSlideUp(
                delay: AppAnimations.sectionDelay * 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
