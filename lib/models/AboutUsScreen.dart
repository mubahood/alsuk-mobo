import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';

import '../theme/app_theme.dart'; // Using the established AppTheme
import '../utils/AppConfig.dart';
import '../utils/Utils.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  AboutUsScreenState createState() => AboutUsScreenState();
}

class AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    // Using the app's theme for consistency
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      // A light, clean background color
      backgroundColor: AppTheme.theme.colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(FeatherIcons.chevronLeft,
              color: theme.colorScheme.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: FxText.titleLarge("About Al Suk", fontWeight: 700),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- App Logo and Title Section ---
              Row(
                children: [
                  Image.asset(
                    AppConfig.logo1, // Assuming your logo is in AppConfig
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConfig.app_name, // "Al Suk"
                        style: textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Your Local Marketplace",
                        style: textTheme.bodyLarge
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // --- Version Information Section ---
              _buildInfoRow("Version", "1.0.0 (Initial Release)"),
              _buildInfoRow("Last Update", "June 2025"),
              const SizedBox(height: 24),

              // --- About Text Section ---
              Text(
                "Our Mission",
                style:
                    textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Al Suk is a dedicated buy-and-sell platform built for the people of South Sudan. Our mission is to create a simple, trusted, and accessible digital marketplace that connects local communities, empowers entrepreneurs, and makes commerce easier for everyone.',
                style: textTheme.bodyLarge
                    ?.copyWith(color: Colors.grey.shade700, height: 1.5),
              ),
              const SizedBox(height: 24),
              Text(
                'Whether you are looking to find great deals on new and used items, or you are a local business seeking to reach more customers, Al Suk provides the tools you need to trade with confidence. We connect buyers and sellers directly through our secure and easy-to-use chat system.',
                style: textTheme.bodyLarge
                    ?.copyWith(color: Colors.grey.shade700, height: 1.5),
              ),
              const SizedBox(height: 40),

              // --- Terms of Service Button ---
              Center(
                child: FxButton(
                  onPressed: () {
                    Utils.launchBrowser(AppConfig.terms);
                  },
                  backgroundColor: CustomTheme.primary,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: FxText.bodyLarge(
                    "Terms of Service",
                    color: Colors.white,
                    fontWeight: 600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A helper widget to create consistent info rows.
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}