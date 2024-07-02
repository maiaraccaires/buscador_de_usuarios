import 'package:buscador_de_usuarios/app/views/user/user_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/repositories_controller.dart';
import '../../../controllers/users_controller.dart';

class ListUsersWidget extends StatefulWidget {
  const ListUsersWidget({super.key});

  @override
  State<ListUsersWidget> createState() => _ListUsersWidgetState();
}

class _ListUsersWidgetState extends State<ListUsersWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsersController>(
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
            if (value.users!.isEmpty) {
              return const Center(
                  child: Text("Não há usuário(s) com este(s) dado(s)"));
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      Text("${value.result!.total} usuário(s) encontrado(s)"),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.users!.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        padding: const EdgeInsets.all(0),
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: InkWell(
                            onTap: () {
                              Provider.of<RepositoriesController>(context,
                                      listen: false)
                                  .getRepositories(
                                      url: value.users![index].repositories!);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: ((context) => UserDetailPage(
                                      username: value.users![index].username)),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  child: ClipOval(
                                    child: Image.network(
                                      value.users![index].avatar,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    value.users![index].username,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
              ],
            );
        }
      },
    );
  }
}
