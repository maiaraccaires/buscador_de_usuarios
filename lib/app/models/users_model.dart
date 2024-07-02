import 'dart:convert';

class ResultSearchModel {
  int total;
  List<UsersModel> items;

  ResultSearchModel({
    required this.total,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory ResultSearchModel.fromMap(Map<String, dynamic> map) {
    return ResultSearchModel(
      total: map['total_count']?.toInt() ?? 0,
      items: List<UsersModel>.from(
          map['items']?.map((x) => UsersModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultSearchModel.fromJson(String source) =>
      ResultSearchModel.fromMap(json.decode(source));
}

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
