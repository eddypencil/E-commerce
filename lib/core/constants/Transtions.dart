import 'package:flutter/material.dart';

class SlideInPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideInPageRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Animation starts off-screen to the left and slides to center
            final begin = const Offset(-1.0, 0.0);
            final end = Offset.zero;
            final curve = Curves.easeInOut;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
}
