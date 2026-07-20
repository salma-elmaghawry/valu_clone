import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_wait/core/injection/injection_container.dart';
import 'package:no_wait/core/routes/routes.dart';
import 'package:no_wait/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:no_wait/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:no_wait/features/auth/presentation/screens/intro_screen.dart';
import 'package:no_wait/features/auth/presentation/screens/login_screen.dart';
import 'package:no_wait/features/auth/presentation/screens/register_screen.dart';
import 'package:no_wait/features/auth/presentation/screens/splash_screen.dart';
import 'package:no_wait/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.intro:
        return MaterialPageRoute(builder: (_) => const IntroScreen());

      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const LoginScreen(),
          ),
        );

      case Routes.signUp:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const RegisterScreen(),
          ),
        );

      case Routes.forgotPassword:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => getIt<AuthCubit>(),
            child: const ForgotPasswordScreen(),
          ),
        );

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
