import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/repositories_model.dart';
import '../services/api/github_service_impl.dart';

enum RepositoriesState { idle, loading, success, error }

class RepositoriesController with ChangeNotifier {
  final GitHubServiceImpl service;

  RepositoriesController({required this.service});

  final _client = Client();

  List<RepositoriesModel>? _repos;
  RepositoriesState _state = RepositoriesState.idle;
  String? _errorMessage;

  List<RepositoriesModel>? get repos => _repos;

  RepositoriesState get status => _state;
  String? get errorMessage => _errorMessage;

  Future<void> getRepositories({required String url}) async {
    _state = RepositoriesState.loading;
    notifyListeners();
    try {
      _repos = await service.getRepositories(_client, endpoint: url);
      _repos!.sort(
          (a, b) => b.updatedAt.toString().compareTo(a.updatedAt.toString()));
      _state = RepositoriesState.success;
      notifyListeners();
    } catch (e) {
      _state = RepositoriesState.error;
      _errorMessage = e.toString();
    }
  }
}
