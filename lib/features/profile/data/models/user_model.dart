import '../../domain/entities/user_entity.dart';

class UserModel {
  final String login;
  final String? name;
  final String avatarUrl;
  final String? bio;
  final String? company;
  final String? location;
  final int followersCount;
  final int followingCount;
  final int repositoriesCount;

  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    int getCount(String key) {
      final val = json[key];
      if (val is Map<String, dynamic>) {
        return (val['totalCount'] as num?)?.toInt() ?? 0;
      }
      return 0;
    }

    return UserModel(
      login: json['login'] as String? ?? '',
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String? ?? '',
      bio: json['bio'] as String?,
      company: json['company'] as String?,
      location: json['location'] as String?,
      followersCount: getCount('followers'),
      followingCount: getCount('following'),
      repositoriesCount: getCount('repositories'),
    );
  }

  UserEntity toEntity() => UserEntity(
        login: login,
        name: name,
        avatarUrl: avatarUrl,
        bio: bio,
        company: company,
        location: location,
        followersCount: followersCount,
        followingCount: followingCount,
        repositoriesCount: repositoriesCount,
      );
}
