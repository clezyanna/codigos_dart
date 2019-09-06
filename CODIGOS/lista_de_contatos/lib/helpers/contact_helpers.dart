import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String contactTable = "contactTable";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class Contato{
  String nome;
  int id;
  String email;
  String phone;
  String img;





  Contato();


   Contato.fromMap(Map map){
     id = map[idColumn];
     nome = map[nomeColumn];
     email = map[emailColumn];
     img = map[imgColumn];
     phone = map[phone];
   }
  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      phoneColumn: phone,
      imgColumn: img
    };
    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }


}


class ContatoProvider {

  Database _db; //declarando a base, e colocar _db para não acessar de fora diretamente


//pegar o banco
  Future<Database> get db async {
    if(_db != null){
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  //
  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contactsnew.db");

    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $contactTable($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn TEXT,"
              "$phoneColumn TEXT, $imgColumn TEXT)"
      );
    });
  }
  Future<Contato> insert(Contato contato)async{
    contato.id = await db.insert(tableContato, contato.toMap());
    return contato;
  }
}




