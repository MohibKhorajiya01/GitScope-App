import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/profile_provider.dart';
import '../../../repositories/presentation/providers/repositories_provider.dart';
import '../../../repositories/presentation/widgets/repo_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/skeleton_loader.dart';
import '../../../../shared/widgets/error_view.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String login;

  const ProfileScreen({super.key, required this.login});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold =
        _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.offset >= threshold) {
      ref
          .read(repositoriesNotifierProvider(widget.login).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider(widget.login));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '@${widget.login}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () {
              ref.invalidate(userProfileProvider(widget.login));
              ref
                  .read(repositoriesNotifierProvider(widget.login).notifier)
                  .refresh();
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const ProfileSkeletonLoader(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(userProfileProvider(widget.login)),
        ),
        data: (user) => _ProfileBody(
          user: user,
          login: widget.login,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}

class _ProfileBody extends ConsumerWidget {
  final UserEntity user;
  final String login;
  final ScrollController scrollController;

  const _ProfileBody({
    required this.user,
    required this.login,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repoState = ref.watch(repositoriesNotifierProvider(login));

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        // Profile Header
        SliverToBoxAdapter(
          child: _ProfileHeader(user: user),
        ),

        // Repositories header
        SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.folder_open_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Repositories',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    user.repositoriesCount.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Repo list or skeleton
        if (repoState.isInitialLoading)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const RepoCardSkeleton(),
                childCount: 5,
              ),
            ),
          )
        else if (repoState.failure != null && repoState.repos.isEmpty)
          SliverToBoxAdapter(
            child: ErrorView(
              error: repoState.failure!,
              onRetry: () => ref
                  .read(repositoriesNotifierProvider(login).notifier)
                  .refresh(),
            ),
          )
        else
          SliverPadding(
            padding:
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < repoState.repos.length) {
                    return RepoCard(repo: repoState.repos[index]);
                  }
                  return null;
                },
                childCount: repoState.repos.length,
              ),
            ),
          ),

        // Load more indicator
        if (repoState.isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
          ),

        // End of list message
        if (!repoState.hasNextPage &&
            repoState.repos.isNotEmpty &&
            !repoState.isInitialLoading)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  AppStrings.noMoreRepos,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),

        // Bottom safe area
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar + Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border, width: 2),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.avatarUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.border,
                        size: 36,
                      ),
                    ),
                    errorWidget: (ctx, url, err) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.person_rounded,
                        color: AppColors.border,
                        size: 36,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (user.name?.isNotEmpty == true) ...[
                      Text(
                        user.name!,
                        style:
                            Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Text(
                      '@${user.login}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Bio
          if (user.bio?.isNotEmpty == true) ...[
            const SizedBox(height: 14),
            Text(
              user.bio!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.text,
                    height: 1.5,
                    fontSize: 14,
                  ),
            ),
          ],

          const SizedBox(height: 14),

          // Location + Company
          Wrap(
            spacing: 16,
            runSpacing: 6,
            children: [
              if (user.company?.isNotEmpty == true)
                _MetaChip(
                  icon: Icons.business_rounded,
                  label: user.company!,
                ),
              if (user.location?.isNotEmpty == true)
                _MetaChip(
                  icon: Icons.location_on_rounded,
                  label: user.location!,
                ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  value: _formatCount(user.followersCount),
                  label: AppStrings.followers,
                ),
                _Divider(),
                _StatItem(
                  value: _formatCount(user.followingCount),
                  label: AppStrings.following,
                ),
                _Divider(),
                _StatItem(
                  value: _formatCount(user.repositoriesCount),
                  label: AppStrings.repositories,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: AppColors.border,
    );
  }
}
