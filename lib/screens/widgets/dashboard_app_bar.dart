import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:nudipu/data/my_colors.dart';

import '../../../../theme/app_theme.dart';
import '../../../../utils/AppConfig.dart';

class DashboardAppBar extends StatelessWidget {
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const DashboardAppBar({
    super.key,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: FxSpacing.only(
          left: 10,
          right: 16,
          top: 8,
          bottom: 2,
        ),
        child: Row(
          children: [
            Image.asset(
              AppConfig.logo_2,
              width: 75,
              height: 30,
              fit: BoxFit.fill,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: onSearchTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: CustomTheme.primary.withAlpha(100)),
                  ),
                  child: Row(
                    children: [
                      Icon(FeatherIcons.search,
                          size: 18, color: CustomTheme.primary),
                      const SizedBox(width: 8),
                      FxText.bodyMedium(
                        'Search for products ... ',
                        color: AppTheme.theme.colorScheme.onBackground
                            .withAlpha(150),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
