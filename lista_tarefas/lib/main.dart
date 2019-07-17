import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _toDoList = [];
  Map<String, dynamic> _last;
  int _lastPosition;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data); 
      });
    });
  }
  
  final _taskController = TextEditingController();

  Future<Null> _refresh() async{
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _toDoList.sort((a, b){
        if (a["ok"] && !b["ok"]) return 1;
        else if (!a["ok"] && b["ok"]) return -1;
        else return 0;
      });
    });
    _saveData();
    return null;
  }
  
  void _addToDo(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _taskController.text;
      _taskController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }
  
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e){
      return null;
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Nova Tarefa",
                      labelStyle: TextStyle(color: Colors.blueAccent)
                    ),
                    controller: _taskController,
                  ),
                ),
                RaisedButton(
                  color: Colors.blueAccent,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: _toDoList.length,
                itemBuilder: buildItem,
              ),
              onRefresh: _refresh,
            )
          )
        ],
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      background: Container(
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete_forever, color: Colors.white)
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ?
            Icons.check : Icons.error_outline)),
        onChanged: (c) {
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveData();
          });
        },
      ), 
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      onDismissed: (direction){
        _last = Map.from(_toDoList[index]);
        _lastPosition = index;
        setState(() {
          _toDoList.removeAt(index);
          _saveData(); 
        });

        final snack = SnackBar(
          content: Text("Task \"${_last["title"]}\" removed!"),
          action: SnackBarAction(
            label: "Undo!",
            onPressed: (){
              setState(() {
                _toDoList.insert(_lastPosition, _last);
                _saveData();
              });
            },
          ),
          duration: Duration(seconds: 3),
        );
        Scaffold.of(context).removeCurrentSnackBar();
        Scaffold.of(context).showSnackBar(snack);

      },
    );
  }
}
