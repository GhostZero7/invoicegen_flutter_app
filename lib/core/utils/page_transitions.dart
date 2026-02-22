import 'package:flutter/material.dart';

/// Custom page route with smooth slide transition
class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final SlideDirection direction;

  SmoothPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.direction = SlideDirection.rightToLeft,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: _getBeginOffset(),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: curve,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  Offset _getBeginOffset() {
    switch (direction) {
      case SlideDirection.rightToLeft:
        return const Offset(1.0, 0.0);
      case SlideDirection.leftToRight:
        return const Offset(-1.0, 0.0);
      case SlideDirection.topToBottom:
        return const Offset(0.0, -1.0);
      case SlideDirection.bottomToTop:
        return const Offset(0.0, 1.0);
    }
  }
}

/// Fade transition page route
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;
  final Curve curve;

  FadePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: child,
    );
  }
}

/// Scale transition page route
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;
  final Duration duration;
  final Curve curve;

  ScalePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Slide direction enum
enum SlideDirection {
  rightToLeft,
  leftToRight,
  topToBottom,
  bottomToTop,
}

/// Extension on Navigator for easy access to smooth transitions
extension NavigatorExtensions on NavigatorState {
  /// Push with smooth slide transition
  Future<T?> pushSmooth<T extends Object?>(
    Widget page, {
    SlideDirection direction = SlideDirection.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return push<T>(SmoothPageRoute<T>(
      child: page,
      direction: direction,
      duration: duration,
      curve: curve,
    ));
  }

  /// Push with fade transition
  Future<T?> pushFade<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOut,
  }) {
    return push<T>(FadePageRoute<T>(
      child: page,
      duration: duration,
      curve: curve,
    ));
  }

  /// Push with scale transition
  Future<T?> pushScale<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return push<T>(ScalePageRoute<T>(
      child: page,
      duration: duration,
      curve: curve,
    ));
  }

  /// Push and replace with smooth transition
  Future<T?> pushReplacementSmooth<T extends Object?, TO extends Object?>(
    Widget page, {
    SlideDirection direction = SlideDirection.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    TO? result,
  }) {
    return pushReplacement<T, TO>(
      SmoothPageRoute<T>(
        child: page,
        direction: direction,
        duration: duration,
        curve: curve,
      ),
      result: result,
    );
  }
}

/// Extension on BuildContext for easy navigation
extension ContextNavigationExtensions on BuildContext {
  /// Push with smooth slide transition
  Future<T?> pushSmooth<T extends Object?>(
    Widget page, {
    SlideDirection direction = SlideDirection.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.of(this).pushSmooth<T>(
      page,
      direction: direction,
      duration: duration,
      curve: curve,
    );
  }

  /// Push with fade transition
  Future<T?> pushFade<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 250),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.of(this).pushFade<T>(
      page,
      duration: duration,
      curve: curve,
    );
  }

  /// Push with scale transition
  Future<T?> pushScale<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return Navigator.of(this).pushScale<T>(
      page,
      duration: duration,
      curve: curve,
    );
  }

  /// Push and replace with smooth transition
  Future<T?> pushReplacementSmooth<T extends Object?, TO extends Object?>(
    Widget page, {
    SlideDirection direction = SlideDirection.rightToLeft,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    TO? result,
  }) {
    return Navigator.of(this).pushReplacementSmooth<T, TO>(
      page,
      direction: direction,
      duration: duration,
      curve: curve,
      result: result,
    );
  }

  /// Show dialog with smooth scale animation
  Future<T?> showSmoothDialog<T>({
    required Widget dialog,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return showGeneralDialog<T>(
      context: this,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      barrierLabel: barrierLabel,
      transitionDuration: duration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) => dialog,
    );
  }

  /// Show modal bottom sheet with smooth slide animation
  Future<T?> showSmoothModalBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) {
    return showGeneralDialog<T>(
      context: this,
      barrierDismissible: isDismissible,
      barrierLabel: isDismissible ? MaterialLocalizations.of(this).modalBarrierDismissLabel : null,
      barrierColor: Colors.black54,
      transitionDuration: duration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          )),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: backgroundColor ?? Theme.of(this).bottomSheetTheme.backgroundColor,
            elevation: elevation ?? 0,
            shape: shape ?? const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            clipBehavior: clipBehavior ?? Clip.antiAlias,
            child: Container(
              constraints: constraints,
              width: double.infinity,
              child: isScrollControlled 
                ? child 
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(this).size.height * 0.75,
                    ),
                    child: child,
                  ),
            ),
          ),
        );
      },
    );
  }
}