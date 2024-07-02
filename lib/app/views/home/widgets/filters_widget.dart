import 'package:flutter/material.dart';

class FilterWidget extends StatefulWidget {
  final Function(Map<String, String>)? applyFilter;
  final VoidCallback? clearFilter;

  const FilterWidget({super.key, this.applyFilter, this.clearFilter});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final controllerSearch = TextEditingController();
  final controllerLocation = TextEditingController();
  final controllerLanguage = TextEditingController();
  final controllerRepos = TextEditingController();
  final controllerFollowers = TextEditingController();
  String filter = "";
  String txt = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 0),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          visualDensity: VisualDensity.compact,
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          title: Text(
            "FILTRAR POR",
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          children: [
            _buildFilterField(
                label: "Localidade",
                controller: controllerLocation,
                filterName: "location",
                type: TextInputType.text,
                hintText: 'Digite uma localização'),
            const SizedBox(
              height: 10,
            ),
            _buildFilterField(
                label: "Linguagem de Programação",
                controller: controllerLanguage,
                filterName: "language",
                type: TextInputType.text,
                hintText: 'Digite uma linguagem de programação'),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildFilterField(
                      label: "Nº de Seguidores",
                      controller: controllerFollowers,
                      filterName: "followers",
                      type: TextInputType.number,
                      hintText: 'Digite nº mín. de seguidores'),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _buildFilterField(
                      label: "Nº de Repositórios",
                      controller: controllerRepos,
                      filterName: "repos",
                      type: TextInputType.number,
                      hintText: 'Digite nº mín. de repositório'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controllerFollowers.clear();
                      controllerLanguage.clear();
                      controllerLocation.clear();
                      controllerRepos.clear();
                      widget.clearFilter!();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text("Limpar filtro"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {
                        final filters = {
                          'field': filter,
                          'value': txt,
                        };

                        widget.applyFilter!(filters);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Aplicar filtro")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterField({
    required String label,
    required TextEditingController controller,
    required String filterName,
    required TextInputType type,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 45,
          child: TextFormField(
            controller: controller,
            onChanged: (value) {
              setState(() {
                filter = filterName;
                txt = value;
              });
            },
            keyboardType: type,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              hintText: hintText,
              hintStyle: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.grey),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
