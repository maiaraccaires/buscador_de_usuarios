import 'package:get_it/get_it.dart';
import 'package:localstorage/localstorage.dart';

import 'services/api/github_service_impl.dart';

GetIt injector = GetIt.instance;

class DependencyInjection {
  static Future<void> inject() async {
    injector.registerSingleton<GitHubServiceImpl>(GitHubServiceImpl());
    injector
        .registerSingleton<LocalStorage>(LocalStorage("buscador_usuarios_app"));
  }
}
