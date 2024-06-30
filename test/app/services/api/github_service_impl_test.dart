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

      final users = await service.searchUser(
        httpClient,
        username: 'maiara',
        filter: 'location',
        value: 'SP',
      );

      expect(users.isNotEmpty, equals(true));
    });

    test("Buscar usuários por linguagem de programação", () async {
      var response = http.Response(jsonUsersByLanguage, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final users = await service.searchUser(
        httpClient,
        username: 'maiara',
        filter: 'language',
        value: 'javascript',
      );

      expect(users.isNotEmpty, equals(true));
    });

    test("Buscar usuários por número de seguidores", () async {
      var response = http.Response(jsonUsersByFollowers, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final users = await service.searchUser(
        httpClient,
        username: 'maiara',
        filter: 'folowers',
        value: '1:15',
      );

      expect(users.isNotEmpty, equals(true));
    });

    test("Buscar usuários por número de repositório", () async {
      var response = http.Response(jsonUsersByRepositories, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final users = await service.searchUser(
        httpClient,
        username: 'maiara',
        filter: 'repos',
        value: '1..30',
      );

      expect(users.isNotEmpty, equals(true));
    });

    test("Buscar usuários por username", () async {
      var response = http.Response(jsonUsersByName, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final users = await service.searchUser(
        httpClient,
        username: 'maiara',
        filter: '',
        value: '',
      );

      expect(users.isNotEmpty, equals(true));
    });

    test("Informar dados de filtro errado", () async {
      var response = http.Response(jsonErrorUnprocessableContent, 422);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final users = await service.searchUser(
        httpClient,
        username: 'maiara',
        filter: 'repos',
        value: 'abc',
      );

      expect(users.isEmpty, equals(true));
    });

    test("Dados não encontrados", () async {
      var response = http.Response(jsonUsersEmpty, 200);

      when(() => httpClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => response);

      final users = await service.searchUser(
        httpClient,
        username: 'maiara',
        filter: 'language',
        value: 'dart',
      );

      expect(users.isEmpty, equals(true));
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
