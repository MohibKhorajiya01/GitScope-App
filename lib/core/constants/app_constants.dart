import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  // GitHub GraphQL API
  static const String githubGraphQLUrl = 'https://api.github.com/graphql';

  // Token key (read from .env file or fallback to --dart-define)
  static String get githubToken =>
      dotenv.env['GITHUB_TOKEN'] ??
      const String.fromEnvironment('GITHUB_TOKEN', defaultValue: '');

  // Pagination
  static const int reposPerPage = 20;

  // App info
  static const String appName = 'GitScope';
  static const String appVersion = '1.0.0';

  // Animation durations
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration shortAnimation = Duration(milliseconds: 250);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
}
