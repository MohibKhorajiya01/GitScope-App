class UserEntity {
  final String login;
  final String? name;
  final String avatarUrl;
  final String? bio;
  final String? company;
  final String? location;
  final int followersCount;
  final int followingCount;
  final int repositoriesCount;

  const UserEntity({
    required this.login,
    this.name,
    required this.avatarUrl,
    this.bio,
    this.company,
    this.location,
    required this.followersCount,
    required this.followingCount,
    required this.repositoriesCount,
  });

  String get displayName => name?.isNotEmpty == true ? name! : login;
}
