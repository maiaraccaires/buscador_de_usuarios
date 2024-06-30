import 'dart:convert';

import 'package:http/http.dart';

import '../../commons/url_github.dart';
import '../../services/api/github_service.dart';
import '../../env/env.dart';
import '../../exceptions/api_exceptions.dart';
import '../../models/repositories_model.dart';
import '../../models/users_model.dart';

class GitHubServiceImpl implements GitHubService {
  final String _domain = urlApi;
  final Map<String, String> _headers = {
    'X-GitHub-Api-Version': AppConfig.dataApi["version"],
    'Authorization': AppConfig.dataApi["token"],
  };

  @override
  Future<List<UsersModel>> searchUser(
    Client client, {
    required String username,
    required String filter,
    required String value,
  }) async {
    try {
      var param =
          filter.isNotEmpty && value.isNotEmpty ? "+$filter:$value" : "";

      final url = Uri.parse("$_domain/search/users?q=$username$param");

      final result = await client.get(url, headers: _headers);

      List list = [];

      if (result.statusCode == 200) {
        var decodedResult = jsonDecode(result.body);
        list = decodedResult["items"] as List;

        return list.map((data) => UsersModel.fromMap(data)).toList();
      } else {
        return <UsersModel>[];
      }
    } catch (e) {
      throw ApiException(object: [], message: e.toString());
    }
  }

  @override
  Future<UsersModel> getDetailUser(
    Client client, {
    required String username,
  }) async {
    try {
      final url = Uri.parse("$_domain/users/$username");

      final result = await client.get(url, headers: _headers);

      if (result.statusCode == 200) {
        var decodedResult = jsonDecode(result.body);

        return UsersModel.fromMap(decodedResult);
      } else {
        return UsersModel(username: '', avatar: '');
      }
    } catch (e) {
      throw ApiException(object: '', message: e.toString());
    }
  }

  @override
  Future<List<RepositoriesModel>> getRepositories(Client client,
      {required String endpoint}) async {
    try {
      final url = Uri.parse(endpoint);
      final result = await client.get(url, headers: _headers);

      List list = [];

      if (result.statusCode == 200) {
        var decodedResult = jsonDecode(result.body);
        list = decodedResult as List;

        return list.map((data) => RepositoriesModel.fromMap(data)).toList();
      } else {
        return <RepositoriesModel>[];
      }
    } catch (e) {
      throw ApiException(object: '', message: e.toString());
    }
  }
}
