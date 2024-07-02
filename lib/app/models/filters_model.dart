import 'dart:convert';

class FiltersModel {
  String filter;
  String value;

  FiltersModel({
    required this.filter,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'filter': filter,
      'value': value,
    };
  }

  factory FiltersModel.fromMap(Map<String, dynamic> map) {
    return FiltersModel(
      filter: map['filter'] ?? '',
      value: map['value'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FiltersModel.fromJson(String source) =>
      FiltersModel.fromMap(json.decode(source));

  @override
  String toString() => 'FiltersModel(filter: $filter, value: $value)';
}
