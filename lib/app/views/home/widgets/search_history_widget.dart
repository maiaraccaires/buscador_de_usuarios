import 'package:buscador_de_usuarios/app/commons/format_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/users_controller.dart';
import '../../user/users_list.dart';

class SearchHistoryWidget extends StatelessWidget {
  const SearchHistoryWidget({super.key});

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
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "PESQUISAS RECENTES",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                      InkWell(
                        onTap: () {
                          value.clearSearchHistory();
                        },
                        child: const Text("Limpar"),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.searchHistory.length,
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: () {
                          Provider.of<UsersController>(context, listen: false)
                              .searchUser(
                                  username: value.searchHistory[index]
                                      ["search"],
                                  filter: value.searchHistory[index]["field"],
                                  value: value.searchHistory[index]["value"]);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => const UsersListPage()),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                value.searchHistory[index]["search"],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                formatDate(
                                    value.searchHistory[index]["access_date"]),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
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
