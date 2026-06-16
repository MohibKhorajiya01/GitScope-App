import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/errors/failures.dart';

part 'profile_provider.g.dart';

@riverpod
Future<UserEntity> userProfile(UserProfileRef ref, String login) async {
  final repo = ref.watch(profileRepositoryProvider);
  final (user, failure) = await repo.getUser(login);

  if (failure != null) {
    throw failure;
  }
  if (user == null) {
    throw const Failure.notFound();
  }
  return user;
}
