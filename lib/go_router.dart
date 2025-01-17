import 'package:flutter/material.dart';
import 'package:flutter_web/main.dart';
import 'package:flutter_web/ui/aboutPage.dart';
import 'package:flutter_web/ui/homePage.dart';
import 'package:flutter_web/ui/login_page.dart';
import 'package:flutter_web/ui/not_found.dart';
import 'package:flutter_web/ui/profile_page.dart';
import 'package:flutter_web/ui/symbol_detail.dart';
import 'package:flutter_web/ui/utils.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  navigatorKey: navigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/login',
  redirect: (context, state) {
    return Utils().getfromCrypto()?["name"] != null ? state.location : '/login';
  },
  errorBuilder: (context, state) {
    return const NotFound();
  },
  // Define your routes here
  routes: [
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) =>
          buildPageWithDefaultTransition(context, state, const LoginPage()),
    ),
    GoRoute(
        path: '/navigatorRail',
        pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context,
            state,
            state.queryParams["tab"] == "0"
                ? const Homepage()
                : state.queryParams["tab"] == "1"
                    ? const AboutPage()
                    : state.queryParams["tab"] == "2"
                        ? const ProfilePage()
                        : const NotFound()),
        routes: [
          GoRoute(
            redirect: (context, state) {
              if (state.extra == null) {
                return "/navigatorRail?tab=0";
              }
              return null;
            },
            path: 'symbolDetail',
            pageBuilder: (context, state) {
              return buildPageWithDefaultTransition(
                  context, state, SymbolDetail(state: state));
            },
          ),
        ]),
  ],
);

CustomTransitionPage buildPageWithDefaultTransition<T>(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
