import 'package:buscador_de_usuarios/app/controllers/repositories_controller.dart';
import 'package:buscador_de_usuarios/app/models/repositories_model.dart';
import 'package:buscador_de_usuarios/app/services/api/github_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockGitHubServiceImpl extends Mock implements GitHubServiceImpl {}

class FakeClient extends Fake implements Client {}

void main() {
  late RepositoriesController controller;
  late MockGitHubServiceImpl mockService;

  setUpAll(() {
    registerFallbackValue(FakeClient());
  });

  group('Testes Repositories Controller', () {
    setUp(() {
      mockService = MockGitHubServiceImpl();
      controller = RepositoriesController(service: mockService);
    });

    test("Listando repositórios", () async {
      when(() =>
          mockService.getRepositories(any(),
              endpoint: any(named: 'endpoint'))).thenAnswer((_) async => [
            RepositoriesModel(
                name: "database_api",
                description: "Project Flutter with SQLite and API",
                url: "https://api.github.com/repos/maiarachagas/database_api",
                updatedAt: "2024-05-17T03:22:22Z",
                createdAt: "2024-05-15T04:16:46Z",
                language: "Dart")
          ]);

      await controller.getRepositories(
          url: 'https://api.github.com/users/maiarachagas/repos');

      expect(controller.repos!.isNotEmpty, equals(true));
      expect(controller.repos![0].name.isNotEmpty, equals(true));
    });
  });
}
