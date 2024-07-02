import 'dart:convert';

import 'package:buscador_de_usuarios/app/models/filters_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../commons/format_date.dart';
import '../../commons/format_filter.dart';
import '../../controllers/users_controller.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<UsersController>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
                          padding: const EdgeInsets.only(top: 10, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "PESQUISAS RECENTES",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
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
                              var filtersModel = (jsonDecode(value
                                      .searchHistory[index]["filters"]
                                      .toString()) as List)
                                  .map(
                                    (e) => FiltersModel.fromMap(e),
                                  )
                                  .toList();

                              return Container(
                                padding: const EdgeInsets.all(0),
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: InkWell(
                                    onTap: () {
                                      controller.searchUser(
                                          username: value.searchHistory[index]
                                              ["search"],
                                          filters: filtersModel);

                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Usuário: ${value.searchHistory[index]["search"]}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                              Text(
                                                formatDate(
                                                    value.searchHistory[index]
                                                        ["access_date"]),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          ),
                                          if (filtersModel.isNotEmpty)
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Filtros:",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors
                                                              .grey.shade600),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: filtersModel
                                                      .map((element) {
                                                    return Text(
                                                      "${formatFilter(element.filter)}: ${element.value}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Colors.grey
                                                                  .shade600),
                                                    );
                                                  }).toList(),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })),
                      ],
                    );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
