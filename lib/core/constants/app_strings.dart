class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'GitScope';
  static const String appTagline = 'GitHub User Explorer';

  // Home
  static const String searchHint = 'Search GitHub username...';
  static const String searchButton = 'Search';
  static const String emptyStateTitle = 'Explore GitHub Profiles';
  static const String emptyStateSubtitle =
      'Enter a GitHub username to view their profile and repositories.';
  static const String tryExamples = 'Try: torvalds, gaearon, JakeWharton';

  // Profile
  static const String followers = 'Followers';
  static const String following = 'Following';
  static const String repositories = 'Repos';
  static const String noLocation = 'No location';
  static const String noBio = 'No bio provided.';

  // Repos
  static const String pinnedRepos = 'Repositories';
  static const String noDescription = 'No description';
  static const String loadingMore = 'Loading more...';
  static const String noMoreRepos = 'All repositories loaded';

  // Errors
  static const String errorTitle = 'Something went wrong';
  static const String errorNetwork =
      'No internet connection.\nPlease check your network and try again.';
  static const String errorNotFound =
      'User not found.\nDouble-check the username and try again.';
  static const String errorRateLimit =
      'GitHub API rate limit reached.\nPlease try again in a few minutes.';
  static const String errorServer =
      'GitHub API is currently unavailable.\nPlease try again later.';
  static const String errorToken =
      'GitHub token is missing or invalid.\nPlease check your .env file setup.';
  static const String tryAgain = 'Try Again';
}
