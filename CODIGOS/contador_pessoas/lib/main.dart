import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _pessoas = 0;
  String _mensagem = "Pode entrar";

  void _quantidadePessoas(int acao){

    setState(() {//Atualizar a tela
      _pessoas += acao;


      if(_pessoas > 10){
        _mensagem =  "LOTADO";
        _pessoas = 10;

      }else if(_pessoas > 0 && _pessoas < 10){
        _mensagem = "Pode entrar!";
      }else{
        _mensagem = "Mundo INVERTIDO";
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      //Pilha
      children: <Widget>[
        Image.asset(
          "img/croco-bit.jpg",
          fit: BoxFit.cover,
          height: 1000,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center, //Ficar no centro
          children: <Widget>[
            Text(
              "Pessoas : $_pessoas",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("+1",
                      style: TextStyle(color: Colors.white, fontSize: 40.0)),
                  onPressed: () => {_quantidadePessoas(1)},
                ),
                FlatButton(
                  //Botão
                  child: Text("-1",
                      style: TextStyle(color: Colors.white, fontSize: 40.0)),
                  onPressed: () => { _quantidadePessoas(-1)},
                )
              ],
            ),
            Text(
               _mensagem,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontStyle: FontStyle.italic))
          ],
        )
      ],
    );
  }
}
