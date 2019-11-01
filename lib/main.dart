import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

void main(){
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _textController = TextEditingController();
  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;


  @override //reescrever o método que é chamado quando se inicializa o estado do widget
  void initState() {
    super.initState();
    _readData().then((data){
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo(){
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo['title'] = _textController.text;
      _textController.text = "";
      newToDo['ok'] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('ToDo List'),
        backgroundColor: Colors.teal,
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
                    decoration: InputDecoration(
                        labelText: 'Nova Tarefa',
                        labelStyle: TextStyle(color: Colors.teal)
                    ),
                    controller: _textController,
                  ),
                ),
                RaisedButton(
                  color: Colors.teal,
                  child: Text('ADD'),
                  textColor: Colors.white,
                  onPressed: _addToDo,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 10.0),
              itemCount: _toDoList.length,
              itemBuilder: buildItem,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(context, index){
   return Dismissible(
     key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
     background: Container(
       color: Colors.red,
       child: Align(
         alignment: Alignment(-0.9, 0.0),
         child: Icon(Icons.delete, color: Colors.white),
       ),
     ),
     direction: DismissDirection.startToEnd,
     child: CheckboxListTile(
   title: Text(_toDoList[index]['title']),
    value: _toDoList[index]['ok'],
    secondary: CircleAvatar(
    child: Icon(
    _toDoList[index]['ok'] ? Icons.check : Icons.error
    ),
    ),
    onChanged: (c){
    setState(() {
    _toDoList[index]['ok'] = c;
    _saveData();
    });
    },
    ),
   );
  }

  //obter arquivo
  Future<File> _getfile() async{
    final directory = await getApplicationDocumentsDirectory(); //retorna o diretório de armazenamento do app
    return File('${directory.path}/data.json'); //especificar o caminho do diretório
  }

  //salvar arquivo
  Future<File> _saveData() async{
    String data = json.encode(_toDoList); //transformar a lista em json
    final file = await _getfile(); //"pegar" o arquivo
    return file.writeAsString(data); // retorna o arquivo como texto
  }

  //ler arquivo
  Future<String> _readData() async{
    try {
      final file = await _getfile();
      return file.readAsString();
    } catch (e){
      return null;
    }
  }

}

