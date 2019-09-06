import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';



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

  List _tarefas = [];
  final _taskController = TextEditingController();



//retornar o arquivo que será utilizado para salvar os dados
//Alt+Enter em cima da classe para importá-la
  Future<File> _getFile() async {
    //pegar o ditetório onde está nosso arquivo
    //esse caminho ele é diferente para Android e iOS e tb, tem a questão das permissões
    //o path_provider ajuda nesse aspecto

    final directory = await getApplicationDocumentsDirectory();

    return File("${directory.path}/data.json");

  }


  Future<File> _saveData() async{
    String data = json.encode(_tarefas);//converte a minha lista para JSON
    final file = await _getFile();
    return file.writeAsString(data);//escrevendo como texto no arquivo
  }

  //para pegar os dados do arquivo, retorna string pois foi armazenado como string
  Future<String> _readData () async{
    try{
      final file = await _getFile();
      return file.readAsString();

    }catch (e)
    {
      return null;
    }
  }

  void _addTask(){
    setState(
            () {
          Map<String, dynamic > novaTask = Map();
          novaTask["titulo"] = 	_taskController.text;
          novaTask["ok"] = false;

          _tarefas.add(novaTask);

          _saveData();
          print("nova TAREFA ADICIONADA");


        }

    );


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
            padding: EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(child: TextField(
                  controller: _taskController,
                  decoration: InputDecoration(
                      labelText: "Tarefa:",
                      labelStyle: TextStyle(color: Colors.blueAccent)
                  ),
                )),
                RaisedButton(onPressed: _addTask,
                  child: Text("ADICIONAR"),
                  color: Colors.blueAccent,
                  textColor: Colors.white,

                )
              ],
            ),
          ),
          Expanded(child: RefreshIndicator(
              onRefresh: () {},
              child: ListView.builder(
                itemCount: _tarefas.length,
                itemBuilder: (context, index) { return
                  Text(_tarefas[index]["titulo"]);
                },
                padding: EdgeInsets.all(10.0),
              ) ))
        ],
      ),
    );
  }
