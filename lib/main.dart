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

  List _toDoList = [];

  @override
  Widget build(BuildContext context) {
    return Container();
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

