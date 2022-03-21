import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
class ToDoPage extends StatefulWidget {
  ToDoPage({Key? key}) : super(key: key);

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final _toDoController = TextEditingController();
  List _toDoList = [];
 
  late Map<String, dynamic> _lastRemoved;
  late int _lastRemovedPosition;

  @override
  void initState() {
    super.initState();

    Persistencia.readData().then((data) {
      setState(() {
        _toDoList = json.decode(data!);
      });
    });
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      Persistencia.saveData(_toDoList);
       final snack = SnackBar(
                    content: Text("Tarefa Adicionada na Lista!"),
                  
                    duration: Duration(seconds: 2),
                  );
                 Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(snack);
    });
  }

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((concluido, n_concluido) {
        if (concluido["ok"] && !n_concluido["ok"])
          return 1;
        else if (!concluido["ok"] && n_concluido["ok"])
          return -1;
        else
          return 0;
      });
      Persistencia.saveData(_toDoList);
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Tarefas!"),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: _toDoController,
                  decoration: InputDecoration(
                    labelText: "Nova Tarefa!",
                    labelStyle: TextStyle(color: Colors.indigo),
                  ),
                )),
                RaisedButton(
                  color: Colors.indigo,
                  child: Text("+"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                ),
             //   Container(),
                
              ],
            ),
          ),
         
        ],
      ),
    );
  }

 
  

 
}

class Persistencia{
   static Future<File>  getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  static Future<File> saveData(_toDoList) async {
    String data = json.encode(_toDoList);
    final file = await getFile();
    return file.writeAsString(data);
  }

 static Future<String?> readData() async {
    try {
      final file = await getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
  
}
