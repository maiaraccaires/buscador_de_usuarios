import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';

import '../models/filters_model.dart';
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
  ResultSearchModel? _result;

  List<UsersModel>? get users => _users;
  UsersModel? get userDetail => _userDetail;
  UserState get status => _state;
  String? get errorMessage => _errorMessage;
  ResultSearchModel? get result => _result;

  Future<void> searchUser({
    required String username,
    required List<FiltersModel> filters,
  }) async {
    _state = UserState.loading;
    notifyListeners();

    try {
      _result = await service.searchUser(
        _client,
        username: username,
        filters: filters,
      );

      _users = _result!.items;

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

  void addToSearchHistory({
    required String username,
    required List<FiltersModel> filters,
  }) {
    final searchHistoryJson = localStorage!.getItem("searchHistory");
    List history = searchHistoryJson != null
        ? List<Map<String, dynamic>>.from(jsonDecode(searchHistoryJson))
        : [];

    history.add({
      "search": username,
      "filters": filters,
      "access_date": DateTime.now().toString()
    });

    localStorage!.setItem("searchHistory", jsonEncode(history));

    loadSearchHistory();
    notifyListeners();
  }

  void loadSearchHistory() {
    final searchHistoryJson = localStorage!.getItem("searchHistory");
    if (searchHistoryJson != null) {
      searchHistory =
          List<Map<String, dynamic>>.from(jsonDecode(searchHistoryJson));

      searchHistory.sort((a, b) =>
          b["access_date"].toString().compareTo(a["access_date"].toString()));

      notifyListeners();
    }
  }

  void clearSearchHistory() {
    searchHistory.clear();
    localStorage!.deleteItem('searchHistory');
    notifyListeners();
  }
}
