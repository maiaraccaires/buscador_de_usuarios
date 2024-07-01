import 'package:buscador_de_usuarios/app/controllers/users_controller.dart';
import 'package:buscador_de_usuarios/app/models/users_model.dart';
import 'package:buscador_de_usuarios/app/services/api/github_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:mocktail/mocktail.dart';

class MockGitHubServiceImpl extends Mock implements GitHubServiceImpl {}

class MockLocalStorage extends Mock implements LocalStorage {}

class FakeClient extends Fake implements Client {}

void main() {
  late UsersController controller;
  late MockGitHubServiceImpl mockService;
  late MockLocalStorage mockStorage;
  final GetIt injector = GetIt.instance;

  setUpAll(() {
    registerFallbackValue(FakeClient());
  });

  group('Testes Users Controller', () {
    setUp(() {
      mockService = MockGitHubServiceImpl();
      mockStorage = MockLocalStorage();

      injector.registerSingleton<GitHubServiceImpl>(mockService);
      injector.registerSingleton<LocalStorage>(mockStorage);

      controller = UsersController(
        service: injector<GitHubServiceImpl>(),
        localStorage: injector<LocalStorage>(),
      );
    });

    tearDown(() {
      injector.reset();
    });

    test("Salvando histórico de pesquisa", () async {
      when(() =>
          mockService.searchUser(any(),
              username: any(named: 'username'),
              filter: any(named: 'filter'),
              value: any(named: 'value'))).thenAnswer((_) async => [
            UsersModel(
                username: 'maiara',
                avatar: 'https://avatars.githubusercontent.com/u/7199836?v=4')
          ]);

      when(() => mockStorage.setItem(any(), any()))
          .thenAnswer((_) async => Future.value());

      await controller.searchUser(
          username: 'maiarachagas', filter: 'language', value: 'java');

      expect(controller.users!.isNotEmpty, equals(true));
    });

    test("Buscando histórico de pesquisa", () {
      when(() => mockStorage.getItem("searchHistory")).thenReturn(
          '[{"search": "maiarachagas", "field": "language", "value": "dart"}]');

      controller.loadSearchHistory();
      expect(controller.searchHistory.isNotEmpty, equals(true));
      expect(controller.searchHistory.first['search'], equals("maiarachagas"));
      expect(controller.searchHistory.first['field'], equals("language"));
      expect(controller.searchHistory.first['value'], equals("dart"));
    });

    test("Limpando histórico de pesquisa", () {
      when(() => mockStorage.getItem("searchHistory")).thenReturn(
          '[{"search": "maiarachagas", "field": "language", "value": "dart"}]');
      when(() => mockStorage.deleteItem("searchHistory"))
          .thenAnswer((_) async => Future.value());

      controller.clearSearchHistory();
      expect(controller.searchHistory.isEmpty, equals(true));
    });

    test("Buscando detalhes do usuário", () async {
      when(() => mockService.getDetailUser(any(),
              username: any(named: 'username')))
          .thenAnswer((_) async => UsersModel(
              username: 'maiarachagas',
              avatar: 'https://avatars.githubusercontent.com/u/7199836?v=4',
              qtyRepos: 100,
              qtyfollowers: 1000,
              qtyfollowing: 20));

      await controller.getDetailUser(username: 'maiarachagas');

      expect(controller.userDetail!.username.isNotEmpty, equals(true));
      expect(controller.userDetail!.username, equals('maiarachagas'));
    });
  });
}
