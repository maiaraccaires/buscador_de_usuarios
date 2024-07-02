import 'package:http/http.dart';

import '../../models/filters_model.dart';
import '../../models/repositories_model.dart';
import '../../models/users_model.dart';

abstract class GitHubService {
  Future<ResultSearchModel> searchUser(
    Client client, {
    required String username,
    required List<FiltersModel> filters,
  });

  Future<UsersModel> getDetailUser(Client client, {required String username});

  Future<List<RepositoriesModel>> getRepositories(Client client,
      {required String endpoint});
}
