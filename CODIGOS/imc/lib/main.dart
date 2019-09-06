import 'package:flutter/material.dart';

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
  String mensagem = "preencha peso e altura";
  TextEditingController pesocontrolador = TextEditingController();
  TextEditingController alturaControlador = TextEditingController();
  GlobalKey<FormState> formControlador = GlobalKey<FormState>();

  void calcular() {
    setState(() {
      if (formControlador.currentState.validate()) {}
      double peso = double.parse(pesocontrolador.text);
      double altura = double.parse(alturaControlador.text);
      double imc = peso / (altura * altura);

      mensagem = "Seu IMC ${imc.toStringAsPrecision(4)}";
    });
  }

  void apagar() {
    setState(() {
      pesocontrolador.text = "";
      alturaControlador.text = "";
      mensagem = "Informe os dados";
      formControlador = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Text("IMC"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.refresh), onPressed: apagar)
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Form(
              key: formControlador,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Icon(
                    Icons.person_outline,
                    size: 120,
                    color: Colors.purple,
                  ),
                  TextFormField(
                    validator: (valor) {
                      if (valor.isEmpty) {
                        return "Campo Obrigatório";
                      }
                    },
                    controller: pesocontrolador,
                    style: TextStyle(color: Colors.purple, fontSize: 20),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Peso(kg):",
                        labelStyle: TextStyle(
                            color: Colors.purple, fontSize: 35) //color do texto
                        ),
                  ),
                  TextFormField(
                    validator: (valor) {
                      //quando chamar para excutar este campo ele vai excutar esse campo
                      if (valor.isEmpty) {
                        return "Campo Obrigatório";
                      }
                    },
                    controller: alturaControlador,
                    style: TextStyle(color: Colors.purple, fontSize: 20),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: "Altura(m):",
                        labelStyle: TextStyle(
                            color: Colors.purple, fontSize: 35) //color do texto
                        ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: RaisedButton(
                        onPressed: calcular,
                        child: Text(
                          "Calcular",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.purple,
                      )),
                  Text(
                    mensagem,
                    style: TextStyle(fontSize: 20, color: Colors.purple),
                  )
                ],
              ),
            )));
  }
}
