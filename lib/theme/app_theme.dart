import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme_type.dart';
import '../utils/Utils.dart';
import 'custom_theme.dart';

export 'custom_theme.dart';
export 'navigation_theme.dart';

class AppTheme {
  static InputDecoration InputDecorationTheme1(
      {bool isDense = true,
      String label = "",
      IconData iconData = Icons.edit,
      String hintText = ""}) {
    return InputDecoration(
      hintText: hintText.isEmpty ? null : hintText,
      isDense: isDense,
      label: (label.isEmpty)
          ? null
          : Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.grey.shade500),
            ),

      /*prefixIcon: Icon(
        iconData,
        color = Colors.grey.shade800,
      ),*/
      hintStyle: const TextStyle(fontSize: 15, color: Color(0xaa495057)),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.green),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      fillColor: Colors.grey.shade100,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.black54)),
    );
  }

  static TextStyle getTextStyle(TextStyle? textStyle,
      {int fontWeight = 500,
      bool muted = false,
      bool xMuted = false,
      double letterSpacing = 0.15,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    double? finalFontSize = fontSize ?? textStyle!.fontSize;

    Color? finalColor;
    if (color == null) {
      finalColor = xMuted
          ? textStyle!.color!.withAlpha(160)
          : (muted ? textStyle!.color!.withAlpha(200) : textStyle!.color);
    } else {
      finalColor = xMuted
          ? color.withAlpha(160)
          : (muted ? color.withAlpha(200) : color);
    }

    return GoogleFonts.ibmPlexSans(
        fontSize: finalFontSize,
        letterSpacing: letterSpacing,
        color: finalColor,
        decoration: decoration,
        height: height,
        wordSpacing: wordSpacing);
  }

  static ThemeData shoppingManagerTheme = getShoppingManagerTheme();

  static ThemeData getShoppingManagerTheme() {
    return createThemeM3(themeType, CustomTheme.primary);
  }

  static ThemeData createThemeM3(ThemeType themeType, Color seedColor) {
    if (themeType == ThemeType.light) {
      return lightTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor, brightness: Brightness.light));
    }
    return lightTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
            onBackground: const Color(0xFFDAD9CA)));
  }

  static ThemeData createTheme(ColorScheme colorScheme) {
    if (themeType != ThemeType.light) {
      return lightTheme.copyWith(
        colorScheme: colorScheme,
      );
    }
    return lightTheme.copyWith(colorScheme: colorScheme);
  }

  static ThemeType themeType = ThemeType.light;
  static TextDirection textDirection = TextDirection.ltr;

  static CustomTheme customTheme = getCustomTheme();
  static ThemeData theme = getTheme();

  static ThemeData shoppingTheme = shoppingLightTheme;

  AppTheme._();

  static ThemeData shoppingLightTheme = createTheme(
    ColorScheme.fromSeed(
      seedColor: CustomTheme.primary,
      primaryContainer: const Color(0xfffdffff),
      secondary: const Color(0xfff15f5f),
      onSecondary: const Color(0xffffffff),
      secondaryContainer: const Color(0xfff8d6d6),
      onSecondaryContainer: const Color(0xff570202),
    ),
  );

  static init() {
    resetFont();
    //FxAppTheme.changeTheme(lightTheme);
    //FxAppTheme.changeDarkTheme(darkTheme);
  }

  static resetFont() {
    FxTextStyle.changeFontFamily(GoogleFonts.mulish);
    FxTextStyle.changeDefaultFontWeight({
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w300,
      500: FontWeight.w400,
      600: FontWeight.w500,
      700: FontWeight.w600,
      800: FontWeight.w700,
      900: FontWeight.w800,
    });
  }

  static ThemeData getTheme([ThemeType? themeType]) {
    return lightTheme;
    themeType = themeType ?? AppTheme.themeType;
    if (themeType == ThemeType.light) return lightTheme;
  }

  static CustomTheme getCustomTheme([ThemeType? themeType]) {
    themeType = themeType ?? AppTheme.themeType;
    if (themeType == ThemeType.light) return CustomTheme.lightCustomTheme;
    return CustomTheme.darkCustomTheme;
  }

  static void changeFxTheme(ThemeType themeType) {
    if (themeType == ThemeType.light) {
      FxAppTheme.changeTheme(lightTheme);
    } else if (themeType == ThemeType.dark) {
      FxAppTheme.changeTheme(lightTheme);
    }
  }

  /// -------------------------- Light Theme  -------------------------------------------- ///
  static final ThemeData lightTheme = ThemeData(
    /// Brightness
    brightness: Brightness.light,

    /// Primary Color
    primaryColor: CustomTheme.primary,
    scaffoldBackgroundColor: const Color(0xffffffff),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: AppBarTheme(
        backgroundColor: CustomTheme.primary,
        titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15),
        iconTheme: IconThemeData(color: Colors.white),
        systemOverlayStyle: Utils.overlay(),
        actionsIconTheme: IconThemeData(color: Colors.white)),

    textTheme: TextTheme(
      titleLarge: GoogleFonts.lato(),
      bodyLarge: GoogleFonts.lato(),
    ),

    /// Floating Action Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: CustomTheme.primary,
        splashColor: const Color(0xffeeeeee).withAlpha(100),
        highlightElevation: 8,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        focusColor: CustomTheme.primary,
        hoverColor: CustomTheme.primary,
        foregroundColor: const Color(0xffeeeeee)),

    /// Divider Theme
    dividerTheme:
        const DividerThemeData(color: Color(0xffe8e8e8), thickness: 1),
    dividerColor: const Color(0xffe8e8e8),

    /// Bottom AppBar Theme
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color(0xffeeeeee), elevation: 2),

    /// CheckBox theme
    checkboxTheme: CheckboxThemeData(
      checkColor: MaterialStateProperty.all(const Color(0xffeeeeee)),
      fillColor: MaterialStateProperty.all(CustomTheme.primary),
    ),

    /// Radio theme
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(CustomTheme.primary),
    ),

    ///Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: MaterialStateProperty.resolveWith((state) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xffabb3ea);
        }
        return null;
      }),
      thumbColor: MaterialStateProperty.resolveWith((state) {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.pressed,
          MaterialState.hovered,
          MaterialState.focused,
          MaterialState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return CustomTheme.primary;
        }
        return null;
      }),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: CustomTheme.primary,
      inactiveTrackColor: CustomTheme.primary,
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: CustomTheme.primary,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      tickMarkShape: const RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Color(0xffeeeeee),
      ),
    ),

    /// Other Colors
    splashColor: Colors.white.withAlpha(100),
    indicatorColor: const Color(0xffeeeeee),
    highlightColor: const Color(0xffeeeeee),
    colorScheme: const ColorScheme.light(
            primary: CustomTheme.primary,
            onPrimary: Color(0xffeeeeee),
            secondary: CustomTheme.primary,
            onSecondary: Color(0xffeeeeee),
            surface: Color(0xffeeeeee),
            background: Color(0xffeeeeee),
            onBackground: Color(0xff495057))
        .copyWith(background: const Color(0xffffffff))
        .copyWith(error: const Color(0xfff0323c)),
  );
}
