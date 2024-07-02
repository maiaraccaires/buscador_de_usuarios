import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import 'controllers/repositories_controller.dart';
import 'controllers/users_controller.dart';
import 'dependency_injection.dart';
import 'services/api/github_service_impl.dart';
import 'views/home/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsersController(
            service: injector<GitHubServiceImpl>(),
            localStorage: injector<LocalStorage>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RepositoriesController(
            service: injector<GitHubServiceImpl>(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Buscador de Usuários',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo.shade300),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
