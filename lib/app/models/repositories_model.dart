import 'dart:convert';

class RepositoriesModel {
  String name;
  String description;
  String url;
  String createdAt;
  String updatedAt;
  String language;

  RepositoriesModel({
    required this.name,
    required this.description,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'url': url,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'language': language,
    };
  }

  factory RepositoriesModel.fromMap(Map<String, dynamic> map) {
    return RepositoriesModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      url: map['url'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
      language: map['language'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RepositoriesModel.fromJson(String source) =>
      RepositoriesModel.fromMap(json.decode(source));
}
