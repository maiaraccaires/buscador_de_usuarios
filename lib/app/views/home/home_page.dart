import 'package:buscador_de_usuarios/app/controllers/users_controller.dart';
import 'package:buscador_de_usuarios/app/views/home/widgets/filters_widget.dart';
import 'package:buscador_de_usuarios/app/views/home/widgets/search_history_widget.dart';
import 'package:buscador_de_usuarios/app/views/user/users_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerSearch = TextEditingController();
  String filter = "";
  String txt = "";

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

    _clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 5),
                      child: Text(
                        "BUSCAR",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
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
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                if (controllerSearch.text.isNotEmpty) {
                                  Provider.of<UsersController>(context,
                                          listen: false)
                                      .searchUser(
                                          username: controllerSearch.text,
                                          filter: filter,
                                          value: txt);
                                  controllerSearch.clear();

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: ((context) =>
                                          const UsersListPage()),
                                    ),
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.search,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    FilterWidget(
                      applyFilter: (value) {
                        if (controllerSearch.text.isNotEmpty) {
                          setState(() {
                            filter = value["field"]!;
                            txt = value["value"]!;
                          });
                          Provider.of<UsersController>(context, listen: false)
                              .searchUser(
                                  username: controllerSearch.text,
                                  filter: filter,
                                  value: txt);

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => const UsersListPage()),
                            ),
                          );
                        }
                      },
                      clearFilter: () {
                        setState(() {
                          _clear();
                          txt = "";
                          filter = "";
                        });
                      },
                    ),
                    const Divider(),
                    const SearchHistoryWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _clear() {
    controllerSearch.clear();
  }
}
