import 'package:buscador_de_usuarios/app/models/filters_model.dart';
import 'package:buscador_de_usuarios/app/services/api/github_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import '../../mocks/github_mock.dart';

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late http.Client httpClient;
  late GitHubServiceImpl service;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  group('Users: ', () {
    setUp(() {
      httpClient = MockClient();
      service = GitHubServiceImpl();
    });

    test('Detalhe do usuário', () async {
      var response = http.Response(jsonUsersByUsername, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final user = await service.getDetailUser(
        httpClient,
        username: 'maiarafag',
      );

      expect(user.username.isNotEmpty, equals(true));
    });

    test('Usuário não encontrado', () async {
      var response = http.Response(jsonErrorNotFound, 404);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final user = await service.getDetailUser(
        httpClient,
        username: 'mayarachagas',
      );

      expect(user.username.isEmpty, equals(true));
    });

    test("Buscar usuários por localidade", () async {
      var response = http.Response(jsonUsersByLocation, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final result = await service.searchUser(httpClient,
          username: 'maiara',
          filters: [FiltersModel(filter: 'location', value: 'sp')]);

      expect(result.items.isNotEmpty, equals(true));
    });

    test("Buscar usuários por linguagem de programação", () async {
      var response = http.Response(jsonUsersByLanguage, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final result = await service.searchUser(httpClient,
          username: 'maiara',
          filters: [FiltersModel(filter: 'language', value: 'javascript')]);

      expect(result.items.isNotEmpty, equals(true));
    });

    test("Buscar usuários por número de seguidores", () async {
      var response = http.Response(jsonUsersByFollowers, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final result = await service.searchUser(httpClient,
          username: 'maiara',
          filters: [FiltersModel(filter: 'folowers', value: '>=15')]);

      expect(result.items.isNotEmpty, equals(true));
    });

    test("Buscar usuários por número de repositório", () async {
      var response = http.Response(jsonUsersByRepositories, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final result = await service.searchUser(httpClient,
          username: 'maiara',
          filters: [FiltersModel(filter: 'repos', value: '>=30')]);

      expect(result.items.isNotEmpty, equals(true));
    });

    test("Buscar usuários por username", () async {
      var response = http.Response(jsonUsersByName, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final result = await service.searchUser(httpClient,
          username: 'maiara', filters: [FiltersModel(filter: '', value: '')]);

      expect(result.items.isNotEmpty, equals(true));
    });

    test("Informar dados de filtro errado", () async {
      var response = http.Response(jsonErrorUnprocessableContent, 422);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final result = await service.searchUser(httpClient,
          username: 'maiara',
          filters: [FiltersModel(filter: 'repos', value: 'abc')]);

      expect(result.items.isEmpty, equals(true));
    });

    test("Dados não encontrados", () async {
      var response = http.Response(jsonUsersEmpty, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final result = await service.searchUser(httpClient,
          username: 'maiara',
          filters: [FiltersModel(filter: 'language', value: 'dart')]);

      expect(result.items.isEmpty, equals(true));
    });

    test("Listar nomes de repositórios do usuário", () async {
      var response = http.Response(jsonRepositories, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final repo = await service.getRepositories(
        httpClient,
        endpoint: 'https://api.github.com/users/maiarachagas/repos',
      );

      expect(repo.isNotEmpty, equals(true));
    });

    test("Usuário não possui repositório", () async {
      var response = http.Response("[]", 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final repo = await service.getRepositories(
        httpClient,
        endpoint: 'https://api.github.com/users/maiara/repos',
      );

      expect(repo.isEmpty, equals(true));
    });
  });
}
