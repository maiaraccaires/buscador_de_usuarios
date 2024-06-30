import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';

import '../models/users_model.dart';
import '../services/api/github_service_impl.dart';

enum UserState { idle, loading, success, error }

class UsersController with ChangeNotifier {
  final GitHubServiceImpl service;
  final LocalStorage? localStorage;

  UsersController({required this.service, this.localStorage});

  final _client = Client();

  List<UsersModel>? _users;
  UsersModel? _userDetail;
  UserState _state = UserState.idle;
  String? _errorMessage;
  List searchHistory = [];

  List<UsersModel>? get users => _users;
  UsersModel? get userDetail => _userDetail;
  UserState get status => _state;
  String? get errorMessage => _errorMessage;

  Future<void> searchUser(
      {required String username,
      required String filter,
      required String value}) async {
    _state = UserState.loading;
    notifyListeners();

    try {
      value = value.isNotEmpty ? value.replaceAll(" ", "+") : value;

      _addToSearchHistory(username: username, filter: filter, value: value);

      _users = await service.searchUser(_client,
          username: username, filter: filter, value: value);

      _state = UserState.success;

      notifyListeners();
    } catch (e) {
      _state = UserState.error;
      _errorMessage = e.toString();
    }
  }

  Future<void> getDetailUser({required String username}) async {
    _state = UserState.loading;
    notifyListeners();
    try {
      _userDetail = await service.getDetailUser(_client, username: username);

      _state = UserState.success;

      notifyListeners();
    } catch (e) {
      _state = UserState.error;
      _errorMessage = e.toString();
    }
  }

  void _addToSearchHistory(
      {required String username,
      required String filter,
      required String value}) {
    List history = [];
    history.add({"search": username, "field": filter, "value": value});

    localStorage!.setItem("searchHistory", jsonEncode(history));

    notifyListeners();
  }

  void loadSearchHistory() {
    final searchHistoryJson = localStorage!.getItem("searchHistory");
    if (searchHistoryJson != null) {
      searchHistory =
          List<Map<String, dynamic>>.from(jsonDecode(searchHistoryJson));
      notifyListeners();
    }
  }

  void clearSearchHistory() {
    searchHistory.clear();
    localStorage!.deleteItem('searchHistory');
    notifyListeners();
  }
}
