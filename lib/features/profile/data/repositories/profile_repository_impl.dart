import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../graphql/user_queries.dart';
import '../models/user_model.dart';

part 'profile_repository_impl.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  final client = ref.watch(graphQLClientProvider);
  return ProfileRepositoryImpl(client);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final GraphQLClient _client;

  ProfileRepositoryImpl(this._client);

  @override
  Future<(UserEntity?, Failure?)> getUser(String login) async {
    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(getUserQuery),
          variables: {'login': login},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        return (null, _mapException(result.exception!));
      }

      final userData = result.data?['user'];
      if (userData == null) {
        return (null, const Failure.notFound());
      }

      final model = UserModel.fromJson(userData as Map<String, dynamic>);
      return (model.toEntity(), null);
    } catch (e) {
      return (null, Failure.server(message: e.toString()));
    }
  }

  Failure _mapException(OperationException exception) {
    final linkError = exception.linkException;
    if (linkError != null) {
      final errorStr = linkError.toString().toLowerCase();
      if (errorStr.contains('rate limit') || errorStr.contains('403')) {
        return const Failure.rateLimit();
      } else if (errorStr.contains('401') || errorStr.contains('bad credentials')) {
        return const Failure.tokenMissing(message: 'Invalid or missing GitHub token.');
      } else if (errorStr.contains('socketexception') || 
                 errorStr.contains('failed host lookup') || 
                 errorStr.contains('network is unreachable') ||
                 errorStr.contains('networkexception')) {
        return const Failure.network();
      }
      return Failure.server(message: 'Server connection issue: $linkError');
    }

    final gqlErrors = exception.graphqlErrors;
    if (gqlErrors.isNotEmpty) {
      final firstError = gqlErrors.first;
      if (firstError.extensions?['code'] == 'RATE_LIMITED' ||
          firstError.message.toLowerCase().contains('rate limit')) {
        return const Failure.rateLimit();
      }
      return Failure.server(message: firstError.message);
    }

    return const Failure.server();
  }
}
