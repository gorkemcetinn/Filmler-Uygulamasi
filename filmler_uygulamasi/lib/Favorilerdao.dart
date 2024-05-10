import 'package:filmler_uygulamasi/Favoriler.dart';
import 'package:filmler_uygulamasi/VeritabaniYardimcisi.dart';
import 'package:sqflite/sqflite.dart';

class Favorilerdao{

  Future<List<Favoriler>> tumFavorileriGetir() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT * FROM favoriler");

    return List.generate(maps.length, (index) {
      var satir = maps[index];

      return Favoriler(satir["id"], satir["film_id"], satir["film_ad"]);
    });
  }

  Future<void> favoriKaydet(int film_id,String film_ad) async{
    
    var db = await VeritabaniYardimcisi.veritabaniErisim();

    var Favoriler = Map<String,dynamic>();
    Favoriler["film_id"] = film_id;
    Favoriler["film_ad"] = film_ad;

    await db.insert("favoriler", Favoriler);
  }

  Future<void> favoriSil(int id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    await db.delete(
      'favoriler',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<void> favorilerTablosunuOlustur(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Favoriler (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        film_id INTEGER,
        film_ad TEXT
      )
    ''');
  }
  

}