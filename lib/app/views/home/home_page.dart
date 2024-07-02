import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/users_controller.dart';
import '../../models/filters_model.dart';
import '../user/search_history_page.dart';
import 'widgets/filters_widget.dart';
import 'widgets/list_users_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerSearch = TextEditingController();
  String filter = "";
  String txt = "";
  List<FiltersModel> filters = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var controller = Provider.of<UsersController>(context, listen: false);
      controller.loadSearchHistory();
    });
  }

  @override
  void dispose() {
    super.dispose();

    controllerSearch.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<UsersController>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 5),
                    child: Text(
                      "BUSCAR",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 45,
                              child: TextFormField(
                                controller: controllerSearch,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  hintText: "Digite um username",
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(color: Colors.grey),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (controllerSearch.text.isNotEmpty) {
                                  controller.addToSearchHistory(
                                      username: controllerSearch.text,
                                      filters: filters);

                                  controller.searchUser(
                                      username: controllerSearch.text,
                                      filters: filters);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(3.0),
                                child: Icon(
                                  Icons.search,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => const SearchHistoryPage()),
                            ),
                          );
                        },
                        child: Text("ver histórico de buscas",
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ),
                  ),
                  FilterWidget(
                    applyFilter: (value) {
                      if (controllerSearch.text.isNotEmpty) {
                        setState(() {
                          filters = value;
                        });
                        controller.addToSearchHistory(
                            username: controllerSearch.text, filters: filters);

                        controller.searchUser(
                            username: controllerSearch.text, filters: filters);
                      }
                    },
                    clearFilter: () {
                      setState(() {
                        filters = [];
                      });
                    },
                  ),
                  const Divider(),
                  const ListUsersWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
