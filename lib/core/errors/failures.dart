import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network({
    @Default('No internet connection. Please check your network.') String message,
  }) = NetworkFailure;

  const factory Failure.notFound({
    @Default('User not found. Please check the username.') String message,
  }) = NotFoundFailure;

  const factory Failure.rateLimit({
    @Default('GitHub API rate limit exceeded. Please try again later.') String message,
  }) = RateLimitFailure;

  const factory Failure.tokenMissing({
    @Default('GitHub token is missing or invalid. Please check your .env file.') String message,
  }) = TokenMissingFailure;

  const factory Failure.server({
    @Default('An unexpected server error occurred.') String message,
  }) = ServerFailure;
}
