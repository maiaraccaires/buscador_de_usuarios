import 'dart:convert';

class UsersModel {
  String username;
  String avatar;
  String? url;
  int? qtyfollowers;
  int? qtyfollowing;
  int? qtyRepos;
  String? repositories;

  UsersModel({
    required this.username,
    required this.avatar,
    this.url,
    this.qtyfollowers,
    this.qtyfollowing,
    this.qtyRepos,
    this.repositories,
  });

  Map<String, dynamic> toMap() {
    return {
      'login': username,
      'avatar': avatar,
      'url': url,
      'followers': qtyfollowers,
      'following': qtyfollowing,
      'public_repos': qtyRepos,
      'repos_url': repositories,
    };
  }

  factory UsersModel.fromMap(Map<String, dynamic> map) {
    return UsersModel(
      username: map['login'] ?? '',
      avatar: map['avatar_url'] ?? '',
      url: map['url'] ?? '',
      qtyfollowers: map['followers']?.toInt() ?? 0,
      qtyfollowing: map['following']?.toInt() ?? 0,
      qtyRepos: map['public_repos']?.toInt() ?? 0,
      repositories: map['repos_url'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UsersModel.fromJson(String source) =>
      UsersModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Users(username: $username)';
  }
}
