import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../../../../theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FxText.titleMedium(
              title.toString().toUpperCase(),
              fontWeight: 700,
              color: Colors.black,
              letterSpacing: -0.2,
            ),
            InkWell(
              onTap: onViewAll,
              child: FxText.bodyMedium(
                'View All',
                fontWeight: 600,
                color: CustomTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
