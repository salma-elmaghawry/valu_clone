import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:no_wait/core/animations/animations.dart';
import 'package:no_wait/core/helpers/extensions.dart';
import 'package:no_wait/core/helpers/spacing.dart';
import 'package:no_wait/core/routes/routes.dart';
import 'package:no_wait/features/home/domain/entities/account_limit_status.dart';
import 'package:no_wait/features/home/presentation/cubit/home_cubit.dart';
import 'package:no_wait/features/home/presentation/cubit/home_state.dart';
import 'package:no_wait/features/home/presentation/widgets/account_status_card.dart';
import 'package:no_wait/features/home/presentation/widgets/bnpl_section.dart';
import 'package:no_wait/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:no_wait/features/home/presentation/widgets/home_header.dart';
import 'package:no_wait/features/home/presentation/widgets/products_grid_section.dart';
import 'package:no_wait/features/home/presentation/widgets/promo_banner_carousel.dart';
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
            onTap: (index) {
              // Only Home is built this sprint; Profile is reachable now
              // since it just hosts the theme toggle. The rest will switch
              // in place once their tabs land.
              if (index == 3) {
                context.pushNamed(Routes.profile);
                return;
              }
              setState(() => _currentTab = index);
            },
          ),
        ),
      ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 4),
      // Header stays pinned above the scroll, matching the reference app.
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                top: 8.h,
                bottom: 12.h,
              ),
              child: const HomeHeader(),
            ).fadeInSlideUp(),
            Expanded(
              child: BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  if (state.isFailure && state.action == HomeAction.fetchSummary) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message ?? '')),
                    );
                  }
                },
                builder: (context, state) {
                  final isInitialLoading =
                      state.isLoading && state.shopItProducts.isEmpty;

                  return SingleChildScrollView(
                    padding: EdgeInsetsDirectional.only(bottom: 96.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: isInitialLoading
                          ? _buildSkeleton(sidePadding)
                          : _buildContent(context, sidePadding, state),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSkeleton(EdgeInsetsDirectional sidePadding) {
    return [
      Padding(
        padding: sidePadding,
        child: AnimatedSkeleton(
          width: double.infinity,
          height: 120.h,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      verticalSpace(16),
      Padding(
        padding: sidePadding,
        child: AnimatedSkeleton(
          width: double.infinity,
          height: 100.h,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      verticalSpace(16),
      Padding(
        padding: sidePadding,
        child: AnimatedSkeleton(
          width: double.infinity,
          height: 170.h,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    ];
  }

  List<Widget> _buildContent(
    BuildContext context,
    EdgeInsetsDirectional sidePadding,
    HomeState state,
  ) {
    return [
      const PromoBannerCarousel().fadeInSlideUp(
        delay: AppAnimations.sectionDelay,
      ),
      verticalSpace(16),
      Padding(
        padding: sidePadding,
        child: const BnplSection(),
      ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 2),
      if (state.accountStatus != AccountLimitStatus.active) ...[
        verticalSpace(16),
        Padding(
          padding: sidePadding,
          child: AccountStatusCard(status: state.accountStatus),
        ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 3),
      ],
      verticalSpace(20),
      ShopItSection(
        products: state.shopItProducts,
      ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 4),
      verticalSpace(20),
      Padding(
        padding: sidePadding,
        child: ProductsGridSection(services: state.quickAccessServices),
      ).fadeInSlideUp(delay: AppAnimations.sectionDelay * 5),
    ];
  }
}
