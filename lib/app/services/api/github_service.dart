import 'package:http/http.dart';

import '../../models/repositories_model.dart';
import '../../models/users_model.dart';

abstract class GitHubService {
  Future<List<UsersModel>> searchUser(Client client,
      {required String username,
      required String filter,
      required String value});

  Future<UsersModel> getDetailUser(Client client, {required String username});

  Future<List<RepositoriesModel>> getRepositories(Client client,
      {required String endpoint});
}