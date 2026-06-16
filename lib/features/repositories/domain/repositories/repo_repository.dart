import '../../../../core/errors/failures.dart';
import '../entities/repository_entity.dart';

class RepositoriesPage {
  final List<RepositoryEntity> repos;
  final bool hasNextPage;
  final String? endCursor;

  const RepositoriesPage({
    required this.repos,
    required this.hasNextPage,
    this.endCursor,
  });
}

abstract interface class RepoRepository {
  Future<(RepositoriesPage?, Failure?)> getRepositories({
    required String login,
    required int first,
    String? after,
  });
}
