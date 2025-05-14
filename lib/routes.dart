import 'package:flutter/material.dart';
import 'package:vanick/pages/landing_page.dart';
import 'package:vanick/pages/login_page.dart';
import 'package:vanick/pages/register.dart';
import 'package:vanick/splash_screen.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String landing = '/landing';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case landing:
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case register:
        return MaterialPageRoute(builder: (_) => const Register());

      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
