import 'package:evolza_app/Presentation/login_page.dart';
import 'package:evolza_app/Presentation/profile.dart';
import 'package:evolza_app/Presentation/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String loginPath = '/login';
  static const String signUpPath = '/signup';
  static const String profilePath = '/profile';

  static GoRouter get router => _router;

  static final GoRouter _router = GoRouter(
    initialLocation: loginPath,
    routes: [
      GoRoute(
        path: loginPath,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: signUpPath,
        builder: (context, state) => const SignUp(), 
      ),
      GoRoute(
        path: profilePath,
        builder: (context, state) => const Profile(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: Text("Error")),
        body: Center(
          child: Text("Page not found"),
        ),
    ),
  );
}

