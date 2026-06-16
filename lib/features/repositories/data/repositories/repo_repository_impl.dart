import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/graphql/graphql_client.dart';
import '../../domain/repositories/repo_repository.dart';
import '../graphql/repo_queries.dart';
import '../models/repository_model.dart';

part 'repo_repository_impl.g.dart';

@riverpod
RepoRepository repoRepository(RepoRepositoryRef ref) {
  final client = ref.watch(graphQLClientProvider);
  return RepoRepositoryImpl(client);
}

class RepoRepositoryImpl implements RepoRepository {
  final GraphQLClient _client;

  RepoRepositoryImpl(this._client);

  @override
  Future<(RepositoriesPage?, Failure?)> getRepositories({
    required String login,
    required int first,
    String? after,
  }) async {
    try {
      final result = await _client.query(
        QueryOptions(
          document: gql(getUserReposQuery),
          variables: {
            'login': login,
            'first': first,
            if (after != null) 'after': after,
          },
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

      final reposData = userData['repositories'] as Map<String, dynamic>;
      final nodes = reposData['nodes'] as List<dynamic>;
      final pageInfo = reposData['pageInfo'] as Map<String, dynamic>;

      final repos = nodes
          .map((node) =>
              RepositoryModel.fromJson(node as Map<String, dynamic>).toEntity())
          .toList();

      return (
        RepositoriesPage(
          repos: repos,
          hasNextPage: pageInfo['hasNextPage'] as bool,
          endCursor: pageInfo['endCursor'] as String?,
        ),
        null,
      );
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
      if (firstError.message.toLowerCase().contains('rate limit')) {
        return const Failure.rateLimit();
      }
      return Failure.server(message: firstError.message);
    }

    return const Failure.server();
  }
}
