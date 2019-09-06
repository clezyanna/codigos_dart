import 'dart:async';
import 'dart:convert';

import 'package:buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search;

  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;
    String url = "https://api.giphy.com/v1/gifs/trending?api_key=3EJyNjEbuuK8ZD055XE8o5NEghjy7uMx&limit=6&rating=G";
    response = await http.get(url);

    return json.decode(response.body);
  }


  @override
  void initState() {
    super.initState();

    _getGifs().then((map){
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: "Pesquise Aqui!",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder()
              ),
              style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,
              // para pesquisar os GIFs
              // não iremos usar o onChanged, esse usamos para detectar mudança no campo de texto, como no da moeda

              //agora vamos usar o onSubmitted que é quando o clica no OK do teclado,
              // não precisando adicionar um botão, entende?
              //o onSubmitted recebe o texto que tá no textfield
              onSubmitted: (text){

                setState(() {
                  _search = text;//atualiza os widgets, logo o FutureBuilder fazer uma nova requisição de gifs
                  _offset = 0; // toda vez que fizer uma nova busca, começar com offset 0
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot){ //esse função precisa retornar um widget
                  switch(snapshot.connectionState){ //com snapshot verificamos o status da requisição
                    case ConnectionState.waiting: //case para os casos que queremos tratar
                    case ConnectionState.none:// se tiver esperando ou não tenha carregado
                      return Container(//retornar um container com aquele progress bar, circulo rodando
                        width: 200.0,//container do tamanho desse circulo que vai ficar rodando
                        height: 200.0,
                        alignment: Alignment.center, // alinhar no centro
                        child: CircularProgressIndicator( //criando a barra de progresso circular com cor branco e 5 de espessura
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white), //uma animação parada com uma única cor
                          strokeWidth: 5.0, //largura da borda desse circulo
                        ),
                      );
                    default:
                      if(snapshot.hasError) return Container(); //se tiver ocorrido um erro, retorna um container vazio, pode mostrar msg de erro
                      else return _createGifTable(context, snapshot); //se tudo ok fazemos o grid com as imagens dos gifs
                  }
                }
            ),
          ),
        ],
      ),
    );
  }

  //essa função aqui é pq o GRID vai ter 20 gifs quando não for feito uma pesquisa
  // e quando for feito uma pesquisa terá 19 gifs + 1 botao (carregar mais gifs)
  // logo indicar a quantidade de elementos do grid depende se foi feito pesquisa
  int _getCount(List data){
    if(_search == null){//se não foi feito pesquisa, será retornado 20 gifs na requisição
      return data.length;
    } else {
      return data.length + 1; //se foi feito pesquisa, retorna 19 gifs, e a gente aumenta 1 aqui para colocar o botão
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder( //o grid é como se fosse uma tabela, uma grade e vc exibe a quantidade de widgets que quiser.
        //nosso caso é com duas colunas
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( //define como os itens serão organizados
          crossAxisCount: 2,//quantos itens na horizontal
          crossAxisSpacing: 10.0, //espaçamento horizontal
          mainAxisSpacing: 10.0 //espaçamento vertical
        ),
        itemCount: _getCount(snapshot.data["data"]), //a quantidade de gifs vem dos dados da requisição
        itemBuilder: (context, index){ //aqui é a mesma coisa do ListView que usamos na aula passada

          //verificar se está pesquisando para então adicionar o botão Carregar Mais
          //neste caso a busca é null (não está pesquisando) ou o indice está dentro do quantidade de gifs
          if(_search == null || index < snapshot.data["data"].length)

            return GestureDetector( //aqui é para permitir que a gente possa clicar na imagem e ser detectado o click
              child: Image.network(snapshot.data["data"][index]["images"]["fixed_height_still"]["url"]),//TODO colocar a URL do gif
              onTap: (){// quando clicar na imagem visualizá-la na outra tela.
                //passa o context, e a rota, uma ponte entre as telas, utilizando o MaterialPageRoute
                //Navigator se responsabilidade de passar para a próxima Tela, basta informar a rota
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))//passa o GIF que foi clicado
                );
              },
              onLongPress: (){//para compartilhar a URL do Gif com pressionando por um bom tempo
                Share.share("https://giphy.com/gifs/Friends-friends-tv-episode-219-eM16dA4eiatuyUs3rA");//TODO colocar a URL do gif
              },
            );
          else

            //se não está pesquisando, mostrar um container com o botão
            return Container(
              child: GestureDetector(//para conseguir interagir com esse item que é o botão
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.add, color: Colors.white, size: 70.0,),
                    Text("Carregar mais...",
                      style: TextStyle(color: Colors.white, fontSize: 22.0),)
                  ],
                ),
                onTap: (){ //o que acontece quando clicar com o dedo, que é chamado de Tap.
                  setState(() {//muda o offset e manda atualizar, a requisição vai ser feita, mas agora com outro offset,
                    // ou seja, os próximos 19 gifs serão retornados por exemplo
                    _offset += 19;
                  });
                },
              ),
            );
        }
    );
  }

}
