// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'colors.dart';
import 'constants.dart';
import 'theme.dart';
import 'theme_data.dart';

// Examples can assume:
// late String userAvatarUrl;

/// A circle that represents a user.
///
/// Typically used with a user's profile image, or, in the absence of
/// such an image, the user's initials. A given user's initials should
/// always be paired with the same background color, for consistency.
///
/// If [foregroundImage] fails then [backgroundImage] is used. If
/// [backgroundImage] fails too, [backgroundColor] is used.
///
/// The [onBackgroundImageError] parameter must be null if the [backgroundImage]
/// is null.
/// The [onForegroundImageError] parameter must be null if the [foregroundImage]
/// is null.
///
/// {@tool snippet}
///
/// If the avatar is to have an image, the image should be specified in the
/// [backgroundImage] property:
///
/// ```dart
/// CircleAvatar(
///   backgroundImage: NetworkImage(userAvatarUrl),
/// )
/// ```
/// {@end-tool}
///
/// The image will be cropped to have a circle shape.
///
/// {@tool snippet}
///
/// If the avatar is to just have the user's initials, they are typically
/// provided using a [Text] widget as the [child] and a [backgroundColor]:
///
/// ```dart
/// CircleAvatar(
///   backgroundColor: Colors.brown.shade800,
///   child: Text('AH'),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Chip], for representing users or concepts in long form.
///  * [ListTile], which can combine an icon (such as a [FluentCircleAvatar]) with
///    some text for a fixed height list entry.
///  * <https://material.io/design/components/chips.html#input-chips>
///
///

double _kStatusIndicatorHeight = 15;
double _kStatusIndicatorBorderWidth = 2;

class FluentCircleAvatar extends StatelessWidget {
  /// Creates a circle that represents a user.
  const FluentCircleAvatar({
    Key? key,
    this.child,
    this.backgroundColor,
    this.backgroundImage,
    this.foregroundImage,
    this.onBackgroundImageError,
    this.onForegroundImageError,
    this.foregroundColor,
    this.radius,
    this.initials = '',
    this.getBackgroundFromInitials = false,
    this.userStatus,
    this.minRadius,
    this.maxRadius,
  })  : assert(radius == null || (minRadius == null && maxRadius == null)),
        assert(backgroundImage != null || onBackgroundImageError == null),
        assert(foregroundImage != null || onForegroundImageError == null),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// Typically a [Text] widget. If the [FluentCircleAvatar] is to have an image, use
  /// [backgroundImage] instead.
  final Widget? child;

  /// The color with which to fill the circle. Changing the background
  /// color will cause the avatar to animate to the new color.
  ///
  /// If a [backgroundColor] is not specified, the theme's
  /// [ThemeData.primaryColorLight] is used with dark foreground colors, and
  /// [ThemeData.primaryColorDark] with light foreground colors.
  final Color? backgroundColor;

  /// The default text color for text in the circle.
  ///
  /// Defaults to the primary text theme color if no [backgroundColor] is
  /// specified.
  ///
  /// Defaults to [ThemeData.primaryColorLight] for dark background colors, and
  /// [ThemeData.primaryColorDark] for light background colors.
  final Color? foregroundColor;

  /// The background image of the circle. Changing the background
  /// image will cause the avatar to animate to the new image.
  ///
  /// Typically used as a fallback image for [foregroundImage].
  ///
  /// If the [FluentCircleAvatar] is to have the user's initials, use [child] instead.
  final ImageProvider? backgroundImage;

  /// The foreground image of the circle.
  ///
  /// Typically used as profile image. For fallback use [backgroundImage].
  final ImageProvider? foregroundImage;

  /// An optional error callback for errors emitted when loading
  /// [backgroundImage].
  final ImageErrorListener? onBackgroundImageError;

  /// An optional error callback for errors emitted when loading
  /// [foregroundImage].
  final ImageErrorListener? onForegroundImageError;

  /// The size of the avatar, expressed as the radius (half the diameter).
  ///
  /// If [radius] is specified, then neither [minRadius] nor [maxRadius] may be
  /// specified. Specifying [radius] is equivalent to specifying a [minRadius]
  /// and [maxRadius], both with the value of [radius].
  ///
  /// If neither [minRadius] nor [maxRadius] are specified, defaults to 20
  /// logical pixels. This is the appropriate size for use with
  /// [ListTile.leading].
  ///
  /// Changes to the [radius] are animated (including changing from an explicit
  /// [radius] to a [minRadius]/[maxRadius] pair or vice versa).
  final double? radius;

  // add status indicator that shows users status
  // if null then it will use normal layout else it will use stack to overlay status
  // incicator
  final UserAvatarStatus? userStatus;

  // initials to display
  // it we need string that has more then 2 charector to generate color from it
  // if child is non null this has no effect
  // TODO: add assertation for length
  final String? initials;

  // weather to auto genrate bg color or use default one
  final bool? getBackgroundFromInitials;

  /// The minimum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [minRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to zero.
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [minRadius] from 10 to
  /// 20 when the [FluentCircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [minRadius] is 40 and the [FluentCircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double? minRadius;

  /// The maximum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [maxRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to [double.infinity].
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [maxRadius] from 10 to
  /// 20 when the [FluentCircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [maxRadius] is 40 and the [FluentCircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double? maxRadius;

  // The default radius if nothing is specified.
  static const double _defaultRadius = 20.0;

  // The default min if only the max is specified.
  static const double _defaultMinRadius = 0.0;

  // The default max if only the min is specified.
  static const double _defaultMaxRadius = double.infinity;

  double get _minDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? minRadius ?? _defaultMinRadius);
  }

  double get _maxDiameter {
    if (radius == null && minRadius == null && maxRadius == null) {
      return _defaultRadius * 2.0;
    }
    return 2.0 * (radius ?? maxRadius ?? _defaultMaxRadius);
  }

  Color _getColorFromInitials(String? str) {
    if (str != null) {
      try {
        var hash = _getIntFromInitials(str);
        var r = (hash & 0xFF0000) >> 16;
        var g = (hash & 0x00FF00) >> 8;
        var b = hash & 0x0000FF;

        var rr = r.toString();
        var gg = g.toString();
        var bb = b.toString();

        return Color(int.parse('0xFF' + rr.substring(rr.length - 2) + gg.substring(gg.length - 2) + bb.substring(bb.length - 2)));
      } catch (err) {
        print('Error: String Must be greater than range 2\n'
            '=========== hash string to hex ===========\n'
            '            string length = ${str.length}');
        // return err.toString();
        return Color(0xffffffff);
      }
    } else {
      return Color(0xffffffff);
    }
  }

  int _getIntFromInitials(String str) {
    int hash = 3000;

    for (int i = 0; i < str.length; i++) {
      hash = ((hash << 4) + hash) + str.codeUnitAt(i);
    }
    return hash;
  }

  _getDiagLength() {
    double circleradius = (radius == null ? _defaultRadius : radius)!;
    double centerX = circleradius;
    double x = ((circleradius * math.cos((math.pi / 180) * 315))) + (centerX) - (_kStatusIndicatorHeight / 2);
    return Offset(x, x);
  }

  _getPadding() {
    bool shouldAddPadding = _getDiagLength().dx + _kStatusIndicatorHeight > (2 * (radius == null ? _defaultRadius : radius)!);
    return shouldAddPadding ? (_kStatusIndicatorHeight / 2) + (radius == null ? _defaultRadius : radius)! : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final ThemeData theme = Theme.of(context);
    TextStyle textStyle = theme.primaryTextTheme.subtitle1!.copyWith(color: foregroundColor);
    Color? effectiveBackgroundColor = backgroundColor;
    if (effectiveBackgroundColor == null) {
      if (getBackgroundFromInitials! && initials != null && initials!.length >= 2) {
        Color colorfromInitials = _getColorFromInitials(initials);
        switch (ThemeData.estimateBrightnessForColor(colorfromInitials)) {
          case Brightness.dark:
            textStyle = theme.primaryTextTheme.subtitle1!.copyWith(color: theme.primaryColorLight);
            effectiveBackgroundColor = colorfromInitials;
            break;
          case Brightness.light:
            textStyle = theme.primaryTextTheme.subtitle1!.copyWith(color: theme.primaryColorDark);
            effectiveBackgroundColor = colorfromInitials;
            break;
        }
      } else {
        switch (ThemeData.estimateBrightnessForColor(textStyle.color!)) {
          case Brightness.dark:
            effectiveBackgroundColor = theme.primaryColorLight;
            break;
          case Brightness.light:
            effectiveBackgroundColor = theme.primaryColorDark;
            break;
        }
      }
    } else if (foregroundColor == null) {
      switch (ThemeData.estimateBrightnessForColor(backgroundColor!)) {
        case Brightness.dark:
          textStyle = textStyle.copyWith(color: theme.primaryColorLight);
          break;
        case Brightness.light:
          textStyle = textStyle.copyWith(color: theme.primaryColorDark);
          break;
      }
    }

    Color statusIndicatorColor = Color(0xffffffff);
    if (userStatus != null) {
      switch (userStatus!) {
        case UserAvatarStatus.offline:
          statusIndicatorColor = Color(0xff8a8886);
          // TODO: Handle this case.
          break;
          statusIndicatorColor = Color(0xff);
        case UserAvatarStatus.online:
          statusIndicatorColor = Color(0xff6bb700);
          // TODO: Handle this case.
          break;
        case UserAvatarStatus.bussy:
          statusIndicatorColor = Color(0xffc50f1f);
          // TODO: Handle this case.
          break;
        case UserAvatarStatus.away:
          statusIndicatorColor = Color(0xffffaa44);
          // TODO: Handle this case.
          break;
      }
    }
    Widget? initialWidget = child == null ? Text(initials!.substring(0, 1)) : null;
    final double minDiameter = _minDiameter;
    final double maxDiameter = _maxDiameter;
    return Padding(
      padding: EdgeInsets.all(_getPadding()),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
              constraints: BoxConstraints(
                minHeight: minDiameter,
                minWidth: minDiameter,
                maxWidth: maxDiameter,
                maxHeight: maxDiameter,
              ),
              duration: kThemeChangeDuration,
              decoration: BoxDecoration(
                color: effectiveBackgroundColor,
                image: backgroundImage != null
                    ? DecorationImage(
                        image: backgroundImage!,
                        onError: onBackgroundImageError,
                        fit: BoxFit.cover,
                      )
                    : null,
                shape: BoxShape.circle,
              ),
              foregroundDecoration: foregroundImage != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: foregroundImage!,
                        onError: onForegroundImageError,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    )
                  : null,
              child: child == null
                  ? initialWidget == null
                      ? null
                      : Center(
                        child: MediaQuery(
                            // Need to ignore the ambient textScaleFactor here so that the
                            // text doesn't escape the avatar when the textScaleFactor is large.
                            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                            child: IconTheme(
                              data: theme.iconTheme.copyWith(color: textStyle.color),
                              child: DefaultTextStyle(
                                style: textStyle.copyWith(color: Colors.white),
                                child: initialWidget == null ? child! : initialWidget,
                              ),
                            ),
                          ),
                      )
                  : Center(
                      child: MediaQuery(
                        // Need to ignore the ambient textScaleFactor here so that the
                        // text doesn't escape the avatar when the textScaleFactor is large.
                        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                        child: IconTheme(
                          data: theme.iconTheme.copyWith(color: textStyle.color),
                          child: DefaultTextStyle(
                            style: textStyle.copyWith(color: Colors.white),
                            child: initialWidget == null ? child! : initialWidget,
                          ),
                        ),
                      ),
                    )),
          if (userStatus != null)
            Positioned(
                height: _kStatusIndicatorHeight,
                width: _kStatusIndicatorHeight,
                top: _getDiagLength().dx,
                left: _getDiagLength().dy,
                child: AnimatedContainer(
                  height: _kStatusIndicatorHeight,
                  width: _kStatusIndicatorHeight,
                  decoration: BoxDecoration(
                    color: statusIndicatorColor,
                    shape: BoxShape.circle,
                    border: Border.all(width: _kStatusIndicatorBorderWidth, color: Color(0xffffffff))
                  ),
                  duration: kThemeChangeDuration,
                )),
        ],
      ),
    );
  }
}

enum UserAvatarStatus { offline, online, bussy, away }
