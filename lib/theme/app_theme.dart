import 'package:flutter/cupertino.dart';

// Colors
class AppColors {
  AppColors._();

  /// Primary brand / tint — iOS system blue (adaptive dark-mode aware)
  static const primary = CupertinoColors.systemBlue;

  /// Destructive action color (delete, logout confirm)
  static const destructive = CupertinoColors.destructiveRed;

  /// Page / scaffold background
  static const background = CupertinoColors.systemBackground;

  /// Grouped table section background
  static const groupedBackground = CupertinoColors.systemGroupedBackground;

  /// Inset grouped section fill
  static const secondaryGroupedBackground =
      CupertinoColors.secondarySystemGroupedBackground;

  /// Primary label / body text
  static const label = CupertinoColors.label;

  /// Secondary label (price, captions)
  static const secondaryLabel = CupertinoColors.secondaryLabel;

  /// Tertiary label (hints, placeholders)
  static const tertiaryLabel = CupertinoColors.tertiaryLabel;

  /// Separator / divider
  static const separator = CupertinoColors.separator;

  /// Input field fill
  static const inputFill = CupertinoColors.tertiarySystemFill;
}

// Typography
class AppTextStyles {
  AppTextStyles._();

  /// Large page title (used below nav bar on list screens)
  static const largeTitle = TextStyle(
    inherit: false,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.37,
    color: CupertinoColors.label,
  );

  /// Navigation bar title
  static const navTitle = TextStyle(
    inherit: false,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    color: CupertinoColors.label,
  );

  /// Section header (all-caps small caption)
  static const sectionHeader = TextStyle(
    inherit: false,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    color: CupertinoColors.secondaryLabel,
  );

  /// Body text
  static const body = TextStyle(
    inherit: false,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.41,
    color: CupertinoColors.label,
  );

  /// Subhead
  static const subhead = TextStyle(
    inherit: false,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.24,
    color: CupertinoColors.label,
  );

  /// Caption / footnote
  static const footnote = TextStyle(
    inherit: false,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.08,
    color: CupertinoColors.secondaryLabel,
  );

  /// Call-to-action button label
  static const buttonLabel = TextStyle(
    inherit: false,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.41,
    color: CupertinoColors.white,
  );
}

// Spacing  (8-pt grid)
class AppSpacing {
  AppSpacing._();

  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

// Border Radius
class AppRadius {
  AppRadius._();

  /// Standard iOS input / card corner radius
  static const double card = 10;
  static const double button = 14;

  static const BorderRadius cardAll = BorderRadius.all(Radius.circular(card));
  static const BorderRadius buttonAll = BorderRadius.all(
    Radius.circular(button),
  );
}

// CupertinoThemeData
final kAppCupertinoTheme = CupertinoThemeData(
  primaryColor: AppColors.primary,
  primaryContrastingColor: CupertinoColors.white,
  brightness: Brightness.light,
  textTheme: CupertinoTextThemeData(
    primaryColor: AppColors.primary,
    textStyle: AppTextStyles.body,
    navTitleTextStyle: AppTextStyles.navTitle,
    navLargeTitleTextStyle: AppTextStyles.largeTitle,
    actionTextStyle: TextStyle(
      inherit: false,
      fontSize: 17,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.41,
      color: AppColors.primary,
    ),
  ),
);

// Hairline Separator  (replaces Material Divider in Cupertino-only app)
class AppDivider extends StatelessWidget {
  final double leftIndent;

  const AppDivider({super.key, this.leftIndent = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: leftIndent),
      height: 0.5,
      color: CupertinoColors.separator.resolveFrom(context),
    );
  }
}
