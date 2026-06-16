class RepositoryEntity {
  final String name;
  final String? description;
  final String? primaryLanguage;
  final String? languageColor;
  final int stargazerCount;
  final int forkCount;
  final bool isPrivate;
  final DateTime? updatedAt;
  final String url;

  const RepositoryEntity({
    required this.name,
    this.description,
    this.primaryLanguage,
    this.languageColor,
    required this.stargazerCount,
    required this.forkCount,
    required this.isPrivate,
    this.updatedAt,
    required this.url,
  });
}
