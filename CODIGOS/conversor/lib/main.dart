import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?formate=json&key=3bf3005e";

void main() async {
  runApp(MaterialApp(home: Home()));
}

Future<Map> getMoedas() async {
  http.Response resposta = await http.get(request);
  return json.decode(resposta.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
       TextEditingController realController = TextEditingController();
       TextEditingController  dolarController = TextEditingController() ;
       double dolarRequisicao;

       void atualizaDolar(String valorReal){

         double real =  double.parse (valorReal);

         dolarController.text= (real / this.dolarRequisicao).toStringAsFixed(2);
       }
       void atualizaReal(StringDolar){
         double dolar = double.parse (dolar);
         dolarController.text= (dolar / this.dolarRequisicao).toStringAsFixed(2);


       }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("   \$Conversor \$"), //imprimir barra
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: getMoedas(),
            builder: (contexto, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text("Carregando Dados.....",
                          style: TextStyle(color: Colors.white)));

                default:
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Erro ao carregar dados",
                          style: TextStyle(color: Colors.white)),
                    );
                  } else {

                    this.dolarRequisicao = snapshot.data['results']['currencies']['USD']['buy'];
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150.0, color: Colors.blue),
                          getTextField("Reais","R\$", realController, atualizaDolar),
                          getTextField("Dolar","USD", dolarController, atualizaReal)

                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

Widget getTextField(String label, String prefix, TextEditingController controlador, Function f){
  return TextField(

          controller: controlador,
          onChanged: f,
          decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color:Colors.white),
              prefixText: "R\$",
              border: OutlineInputBorder()
          )
      );
}