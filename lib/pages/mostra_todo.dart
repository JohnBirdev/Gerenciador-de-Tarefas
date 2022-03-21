import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas/pages/todo_page.dart';
import 'package:provider/src/provider.dart';

import '../core/app_images.dart';


class MostraToDoPage extends StatefulWidget {
  MostraToDoPage({Key? key}) : super(key: key);

  @override
  _MostraToDoPageState createState() => _MostraToDoPageState();
}

class _MostraToDoPageState extends State<MostraToDoPage> {
  List<dynamic> tabela = [];
  late Map<String, dynamic> _lastRemoved;

  late int _lastRemovedPosition;

  @override
  void initState() {
    super.initState();
    Persistencia.readData().then((data) {
      if (data != null && data.isNotEmpty) {
        setState(() => tabela = json.decode(data));
      }
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      tabela.sort((concluido, n_concluido) {
        if (concluido["ok"] && !n_concluido["ok"])
          return 1;
        else if (!concluido["ok"] && n_concluido["ok"])
          return -1;
        else
          return 0;
      });
      Persistencia.saveData(tabela);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Você tem: ${tabela.length} Tarefas a fazer!"),
        centerTitle: true,
      ),
      body: buildListView(tabela),
    );
  }

  Widget buildListView(List<dynamic> tabela) {
    if (tabela.isEmpty) {
      return Center(
        child: Column(
          children: [
            Image.asset(
              AppImages.trophy,
              width: 200,
              height: 400,
            ),
            Text(
              "Parabéns! Você Cumpriu tudo!!!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: tabela.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment(-0.9, 0.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            direction: DismissDirection.startToEnd,
            child: CheckboxListTile(
              title: Text(tabela[index]["title"]),
              value: tabela[index]["ok"],
              secondary: CircleAvatar(
                  child: Icon(
                tabela[index]["ok"] ? Icons.check : Icons.error,
              )),
              onChanged: (check) {
                setState(() {
                  tabela[index]["ok"] = check;

                  Persistencia.saveData(tabela);
                });
              },
            ),
            onDismissed: (direction) {
              setState(() {
                _lastRemoved = Map.from(tabela[index]);
                _lastRemovedPosition = index;
                tabela.removeAt(index);

                Persistencia.saveData(tabela);

                final snack = SnackBar(
                  content:
                      Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
                  action: SnackBarAction(
                      label: "Desfazer",
                      onPressed: () {
                        setState(() {
                          tabela.insert(_lastRemovedPosition, _lastRemoved);
                          Persistencia.saveData(tabela);
                        });
                      }),
                  duration: Duration(seconds: 2),
                );
                Scaffold.of(context).removeCurrentSnackBar();
                Scaffold.of(context).showSnackBar(snack);
              });
            },
          );
        },
      );
    }
  }
}
