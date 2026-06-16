import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border,
      highlightColor: AppColors.surface,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: AppColors.border,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class ProfileSkeletonLoader extends StatelessWidget {
  const ProfileSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonCircle(size: 72),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const SkeletonBox(width: 140, height: 18),
                    const SizedBox(height: 8),
                    const SkeletonBox(width: 100, height: 14),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonBox(width: double.infinity, height: 14),
          const SizedBox(height: 8),
          const SkeletonBox(width: 240, height: 14),
          const SizedBox(height: 24),
          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _statSkeleton(),
              _statSkeleton(),
              _statSkeleton(),
            ],
          ),
          const SizedBox(height: 32),
          const SkeletonBox(width: 120, height: 16),
          const SizedBox(height: 16),
          ...List.generate(3, (_) => const _RepoCardSkeleton()),
        ],
      ),
    );
  }

  Widget _statSkeleton() => Column(
        children: const [
          SkeletonBox(width: 50, height: 20),
          SizedBox(height: 4),
          SkeletonBox(width: 70, height: 12),
        ],
      );
}

class _RepoCardSkeleton extends StatelessWidget {
  const _RepoCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonBox(width: 160, height: 16),
            const SizedBox(height: 8),
            const SkeletonBox(width: double.infinity, height: 13),
            const SizedBox(height: 4),
            const SkeletonBox(width: 200, height: 13),
            const SizedBox(height: 12),
            Row(
              children: const [
                SkeletonBox(width: 60, height: 12),
                SizedBox(width: 16),
                SkeletonBox(width: 40, height: 12),
                SizedBox(width: 16),
                SkeletonBox(width: 40, height: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RepoCardSkeleton extends StatelessWidget {
  const RepoCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const _RepoCardSkeleton();
}
