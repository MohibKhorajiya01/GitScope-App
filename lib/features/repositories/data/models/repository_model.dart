import '../../domain/entities/repository_entity.dart';

class RepositoryModel {
  final String name;
  final String? description;
  final int stargazerCount;
  final int forkCount;
  final bool isPrivate;
  final String? updatedAt;
  final String? primaryLanguageName;
  final String? primaryLanguageColor;
  final String url;

  const RepositoryModel({
    required this.name,
    this.description,
    required this.stargazerCount,
    required this.forkCount,
    required this.isPrivate,
    this.updatedAt,
    this.primaryLanguageName,
    this.primaryLanguageColor,
    required this.url,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    final langJson = json['primaryLanguage'] as Map<String, dynamic>?;
    return RepositoryModel(
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      stargazerCount: (json['stargazerCount'] as num?)?.toInt() ?? 0,
      forkCount: (json['forkCount'] as num?)?.toInt() ?? 0,
      isPrivate: json['isPrivate'] as bool? ?? false,
      updatedAt: json['updatedAt'] as String?,
      primaryLanguageName: langJson?['name'] as String?,
      primaryLanguageColor: langJson?['color'] as String?,
      url: json['url'] as String? ?? '',
    );
  }

  RepositoryEntity toEntity() => RepositoryEntity(
        name: name,
        description: description,
        primaryLanguage: primaryLanguageName,
        languageColor: primaryLanguageColor,
        stargazerCount: stargazerCount,
        forkCount: forkCount,
        isPrivate: isPrivate,
        updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) : null,
        url: url,
      );
}
