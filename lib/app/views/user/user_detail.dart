import 'package:buscador_de_usuarios/app/controllers/repositories_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/users_controller.dart';

class UserDetailPage extends StatefulWidget {
  final String username;
  const UserDetailPage({super.key, required this.username});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();

    var controller = Provider.of<UsersController>(context, listen: false);
    Future.delayed(const Duration(seconds: 0), () {
      controller.getDetailUser(username: widget.username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Consumer<UsersController>(
                  builder: (context, value, child) {
                    switch (value.status) {
                      case UserState.idle:
                        return const Center();
                      case UserState.loading:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case UserState.error:
                        return Center(
                          child: Text(value.errorMessage!),
                        );
                      default:
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          radius: 32,
                                          child: ClipOval(
                                            child: Image.network(
                                              value.userDetail!.avatar,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            value.userDetail!.username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 15, 0, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(Icons.book_outlined,
                                                  size: 18),
                                              Text(
                                                "Repositórios: ${value.userDetail!.qtyRepos}",
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.group_outlined,
                                                  size: 18),
                                              Text(
                                                "Seguidores: ${value.userDetail!.qtyfollowers}",
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.group, size: 18),
                                              Text(
                                                "Seguindo: ${value.userDetail!.qtyfollowing}",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    Consumer<RepositoriesController>(
                                      builder: (context, repoValue, child) {
                                        switch (repoValue.status) {
                                          case RepositoriesState.idle:
                                            return const Center();
                                          case RepositoriesState.loading:
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          case RepositoriesState.error:
                                            return Center(
                                              child:
                                                  Text(repoValue.errorMessage!),
                                            );
                                          default:
                                            return _buildRepositories(
                                                repoValue);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildRepositories(RepositoriesController repoValue) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            "REPOSITÓRIOS",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: repoValue.repos!.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.book, size: 18),
                          Text(
                            repoValue.repos![index].name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(repoValue.repos![index].language.toLowerCase()),
                    ]),
              );
            }),
      ],
    );
  }
}
