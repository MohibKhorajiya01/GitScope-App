import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/repo_repository_impl.dart';
import '../../domain/entities/repository_entity.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';

part 'repositories_provider.g.dart';

/// State class for paginated repository list
class RepositoriesState {
  final List<RepositoryEntity> repos;
  final bool hasNextPage;
  final bool isLoadingMore;
  final bool isInitialLoading;
  final String? endCursor;
  final Failure? failure;

  const RepositoriesState({
    this.repos = const [],
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.isInitialLoading = false,
    this.endCursor,
    this.failure,
  });

  RepositoriesState copyWith({
    List<RepositoryEntity>? repos,
    bool? hasNextPage,
    bool? isLoadingMore,
    bool? isInitialLoading,
    String? endCursor,
    Failure? failure,
    bool clearFailure = false,
    bool clearCursor = false,
  }) {
    return RepositoriesState(
      repos: repos ?? this.repos,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      endCursor: clearCursor ? null : (endCursor ?? this.endCursor),
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }
}

@riverpod
class RepositoriesNotifier extends _$RepositoriesNotifier {
  @override
  RepositoriesState build(String login) {
    Future.microtask(() => _fetchInitial());
    return const RepositoriesState(isInitialLoading: true);
  }

  Future<void> _fetchInitial() async {
    state = state.copyWith(isInitialLoading: true, clearFailure: true);
    final repo = ref.read(repoRepositoryProvider);
    final (page, failure) = await repo.getRepositories(
      login: login,
      first: AppConstants.reposPerPage,
    );

    try {
      if (failure != null) {
        state = state.copyWith(isInitialLoading: false, failure: failure);
        return;
      }
      state = state.copyWith(
        isInitialLoading: false,
        repos: page!.repos,
        hasNextPage: page.hasNextPage,
        endCursor: page.endCursor,
      );
    } catch (_) {
      // Provider was disposed before async completed
    }
  }

  Future<void> loadMore() async {
    if (!state.hasNextPage || state.isLoadingMore) return;

    state = state.copyWith(isLoadingMore: true);
    final repo = ref.read(repoRepositoryProvider);
    final (page, failure) = await repo.getRepositories(
      login: login,
      first: AppConstants.reposPerPage,
      after: state.endCursor,
    );

    try {
      if (failure != null) {
        state = state.copyWith(isLoadingMore: false, failure: failure);
        return;
      }
      state = state.copyWith(
        isLoadingMore: false,
        repos: [...state.repos, ...page!.repos],
        hasNextPage: page.hasNextPage,
        endCursor: page.endCursor,
      );
    } catch (_) {
      // Provider was disposed
    }
  }

  Future<void> refresh() async {
    state = const RepositoriesState(isInitialLoading: true);
    await _fetchInitial();
  }
}
