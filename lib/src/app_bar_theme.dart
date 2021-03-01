// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'text_theme.dart';
import 'theme.dart';

/// Overrides the default values of visual properties for descendant
/// [AppBar] widgets.
///
/// Descendant widgets obtain the current [AppBarTheme] object with
/// `AppBarTheme.of(context)`. Instances of [AppBarTheme] can be customized
/// with [AppBarTheme.copyWith].
///
/// Typically an [AppBarTheme] is specified as part of the overall [Theme] with
/// [ThemeData.appBarTheme].
///
/// All [AppBarTheme] properties are `null` by default. When null, the [AppBar]
/// compute its own default values, typically based on the overall theme's
/// [ThemeData.colorScheme], [ThemeData.textTheme], and [ThemeData.iconTheme].
@immutable
class AppBarTheme with Diagnosticable {
  /// Creates a theme that can be used for [ThemeData.appBarTheme].
  const AppBarTheme({
    this.brightness,
    Color? color,
    Color? backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shadowColor,
    this.iconTheme,
    this.actionsIconTheme,
    this.textTheme,
    this.centerTitle,
    this.titleSpacing,
    this.toolbarTextStyle,
    this.titleTextStyle,
    this.systemOverlayStyle,
    this.backwardsCompatibility,
  }) : assert(
         color == null || backgroundColor == null,
         'The color and backgroundColor parameters mean the same thing. Only specify one.'),
       backgroundColor = backgroundColor ?? color;

  /// This property is obsolete, please use [systemOverlayStyle] instead.
  ///
  /// Overrides the default value of the obsolete [AppBar.brightness]
  /// property which implicitly defines [AppBar.systemOverlayStyle] in
  /// all descendant [AppBar] widgets.
  ///
  /// See also:
  ///
  ///  * [systemOverlayStyle], which overrides the default value of
  ///    [AppBar.systemOverlayStyle] in all descendant [AppBar] widgets.
  ///  * [AppBar.backwardsCompatibility], which forces [AppBar] to depend
  ///    on this obsolete property.
  final Brightness? brightness;

  /// Obsolete property that overrides the default value of
  /// [AppBar.backgroundColor] in all descendant [AppBar] widgets.
  ///
  /// See also:
  ///
  ///  * [backgroundColor], which serves this same purpose
  ///    as this property, but has a name that's consistent with
  ///    [AppBar.backgroundColor].
  ///  * [AppBar.backwardsCompatibility], which forces [AppBar] to depend
  ///    on this obsolete property.
  Color? get color => backgroundColor;

  /// Overrides the default value of [AppBar.backgroundColor] in all
  /// descendant [AppBar] widgets.
  ///
  /// See also:
  ///
  ///  * [foregroundColor], which overrides the default value for
  ///    [AppBar.foregroundColor] in all descendant widgets.
  final Color? backgroundColor;

  /// Overrides the default value of [AppBar.foregroundColor] in all
  /// descendant widgets.
  ///
  /// See also:
  ///
  ///  * [backgroundColor], which overrides the default value for
  ///    [AppBar.backgroundColor] in all descendant [AppBar] widgets.
  final Color? foregroundColor;

  /// Overrides the default value of [AppBar.elevation] in all
  /// descendant [AppBar] widgets.
  final double? elevation;

  /// Overrides the default value for [AppBar.shadowColor] in all
  /// descendant widgets.
  final Color? shadowColor;

  /// Overrides the default value of [AppBar.iconTheme] in all
  /// descendant [AppBar] widgets.
  ///
  /// See also:
  ///
  ///  * [actionsIconTheme], which overrides the default value for
  ///    [AppBar.actionsIconTheme] in all descendant [AppBar] widgets.
  ///  * [foregroundColor], which overrides the default value
  ///    [AppBar.foregroundColor] in all descendant widgets.
  final IconThemeData? iconTheme;

  /// Overrides the default value of [AppBar.actionsIconTheme] in all
  /// descendant widgets.
  ///
  /// See also:
  ///
  ///  * [iconTheme], which overrides the default value for
  ///    [AppBar.iconTheme] in all descendant widgets.
  ///  * [foregroundColor], which overrides the default value
  ///    [AppBar.foregroundColor] in all descendant widgets.
  final IconThemeData? actionsIconTheme;

  /// Overrides the default value of the obsolete [AppBar.textTheme]
  /// property in all descendant [AppBar] widgets.
  ///
  /// See also:
  ///
  ///  * [toolbarTextStyle], which overrides the default value for
  ///    [AppBar.toolbarTextStyle in all descendant [AppBar] widgets.
  ///  * [titleTextStyle], which overrides the default value for
  ///    [AppBar.titleTextStyle in all descendant [AppBar] widgets.
  final TextTheme? textTheme;

  /// Overrides the default value for [AppBar.centerTitle].
  /// property in all descendant widgets.
  final bool? centerTitle;

  /// Overrides the default value for the obsolete [AppBar.titleSpacing]
  /// property in all descendant [AppBar] widgets.
  ///
  /// If null, [AppBar] uses default value of [NavigationToolbar.kMiddleSpacing].
  final double? titleSpacing;

  /// Overrides the default value for the obsolete [AppBar.toolbarTextStyle]
  /// property in all descendant [AppBar] widgets.
  ///
  /// See also:
  ///
  ///  * [titleTextStyle], which overrides the default of [AppBar.titleTextStyle]
  ///    in all descendant [AppBar] widgets.
  final TextStyle? toolbarTextStyle;

  /// Overrides the default value of [AppBar.titleTextStyle]
  /// property in all descendant [AppBar] widgets.
  ///
  /// See also:
  ///
  ///  * [toolbarTextStyle], which overrides the default of [AppBar.toolbarTextStyle]
  ///    in all descendant [AppBar] widgets.
  final TextStyle? titleTextStyle;

  /// Overrides the default value of [AppBar.systemOverlayStyle]
  /// property in all descendant [AppBar] widgets.
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// Overrides the default value of [AppBar.backwardsCompatibility]
  /// property in all descendant [AppBar] widgets.
  final bool? backwardsCompatibility;

  /// Creates a copy of this object with the given fields replaced with the
  /// new values.
  AppBarTheme copyWith({
    IconThemeData? actionsIconTheme,
    Brightness? brightness,
    Color? color,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    Color? shadowColor,
    IconThemeData? iconTheme,
    TextTheme? textTheme,
    bool? centerTitle,
    double? titleSpacing,
    TextStyle? toolbarTextStyle,
    TextStyle? titleTextStyle,
    SystemUiOverlayStyle? systemOverlayStyle,
    bool? backwardsCompatibility,
  }) {
    assert(
      color == null || backgroundColor == null,
      'The color and backgroundColor parameters mean the same thing. Only specify one.');
    return AppBarTheme(
      brightness: brightness ?? this.brightness,
      backgroundColor: backgroundColor ?? color ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      iconTheme: iconTheme ?? this.iconTheme,
      actionsIconTheme: actionsIconTheme ?? this.actionsIconTheme,
      textTheme: textTheme ?? this.textTheme,
      centerTitle: centerTitle ?? this.centerTitle,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      toolbarTextStyle: toolbarTextStyle ?? this.toolbarTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      systemOverlayStyle: systemOverlayStyle ?? this.systemOverlayStyle,
      backwardsCompatibility: backwardsCompatibility ?? this.backwardsCompatibility,
    );
  }

  /// The [ThemeData.appBarTheme] property of the ambient [Theme].
  static AppBarTheme of(BuildContext context) {
    return Theme.of(context).appBarTheme;
  }

  /// Linearly interpolate between two AppBar themes.
  ///
  /// The argument `t` must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static AppBarTheme lerp(AppBarTheme? a, AppBarTheme? b, double t) {
    assert(t != null);
    return AppBarTheme(
      brightness: t < 0.5 ? a?.brightness : b?.brightness,
      backgroundColor: Color.lerp(a?.backgroundColor, b?.backgroundColor, t),
      foregroundColor: Color.lerp(a?.foregroundColor, b?.foregroundColor, t),
      elevation: lerpDouble(a?.elevation, b?.elevation, t),
      shadowColor: Color.lerp(a?.shadowColor, b?.shadowColor, t),
      iconTheme: IconThemeData.lerp(a?.iconTheme, b?.iconTheme, t),
      actionsIconTheme: IconThemeData.lerp(a?.actionsIconTheme, b?.actionsIconTheme, t),
      textTheme: TextTheme.lerp(a?.textTheme, b?.textTheme, t),
      centerTitle: t < 0.5 ? a?.centerTitle : b?.centerTitle,
      titleSpacing: lerpDouble(a?.titleSpacing, b?.titleSpacing, t),
      toolbarTextStyle: TextStyle.lerp(a?.toolbarTextStyle, b?.toolbarTextStyle, t),
      titleTextStyle: TextStyle.lerp(a?.titleTextStyle, b?.titleTextStyle, t),
      systemOverlayStyle: t < 0.5 ? a?.systemOverlayStyle : b?.systemOverlayStyle,
      backwardsCompatibility: t < 0.5 ? a?.backwardsCompatibility : b?.backwardsCompatibility,
    );
  }

  @override
  int get hashCode {
    return hashValues(
      brightness,
      backgroundColor,
      foregroundColor,
      elevation,
      shadowColor,
      iconTheme,
      actionsIconTheme,
      textTheme,
      centerTitle,
      titleSpacing,
      toolbarTextStyle,
      titleTextStyle,
      systemOverlayStyle,
      backwardsCompatibility,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is AppBarTheme
        && other.brightness == brightness
        && other.backgroundColor == backgroundColor
        && other.foregroundColor == foregroundColor
        && other.elevation == elevation
        && other.shadowColor == shadowColor
        && other.iconTheme == iconTheme
        && other.actionsIconTheme == actionsIconTheme
        && other.textTheme == textTheme
        && other.centerTitle == centerTitle
        && other.titleSpacing == titleSpacing
        && other.toolbarTextStyle == toolbarTextStyle
        && other.titleTextStyle == titleTextStyle
        && other.systemOverlayStyle == systemOverlayStyle
        && other.backwardsCompatibility == backwardsCompatibility;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Brightness>('brightness', brightness, defaultValue: null));
    properties.add(ColorProperty('backgroundColor', backgroundColor, defaultValue: null));
    properties.add(ColorProperty('foregroundColor', foregroundColor, defaultValue: null));
    properties.add(DiagnosticsProperty<double>('elevation', elevation, defaultValue: null));
    properties.add(ColorProperty('shadowColor', shadowColor, defaultValue: null));
    properties.add(DiagnosticsProperty<IconThemeData>('iconTheme', iconTheme, defaultValue: null));
    properties.add(DiagnosticsProperty<IconThemeData>('actionsIconTheme', actionsIconTheme, defaultValue: null));
    properties.add(DiagnosticsProperty<TextTheme>('textTheme', textTheme, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('centerTitle', centerTitle, defaultValue: null));
    properties.add(DiagnosticsProperty<double>('titleSpacing', titleSpacing, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('toolbarTextStyle', toolbarTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('titleTextStyle', titleTextStyle, defaultValue: null));
    properties.add(DiagnosticsProperty<bool>('backwardsCompatibility', backwardsCompatibility, defaultValue: null));
  }
}
