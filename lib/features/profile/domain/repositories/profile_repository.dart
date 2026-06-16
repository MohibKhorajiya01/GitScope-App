import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract interface class ProfileRepository {
  Future<(UserEntity?, Failure?)> getUser(String login);
}
