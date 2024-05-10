import 'package:filmler_uygulamasi/Favoriler.dart';
import 'package:filmler_uygulamasi/Favorilerdao.dart';
import 'package:filmler_uygulamasi/FilmlerSayfa.dart';
import 'package:filmler_uygulamasi/Kategorilerdao.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Kategoriler.dart';
import 'VeritabaniYardimcisi.dart';

Future<void> main() async {
  runApp(const MyApp());
  Database db = await VeritabaniYardimcisi.veritabaniErisim();
  VeritabaniYardimcisi().onCreate(db, 1);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {


  Future<List<Kategoriler>> tumKategorileriGoster() async{
    var kategoriListesi = await Kategorilerdao().tumKategorileriGetir();
    return kategoriListesi;
  }

  Future<List<Favoriler>> favroileriGoster() async{

    var favorilerListesi = await Favorilerdao().tumFavorileriGetir();
    return favorilerListesi;
  }

  Future<void> favorilerSil(int film_id) async{
    await Favorilerdao().favoriSil(film_id);
  }


  void _showDraggableBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9, // Başlangıçta kapladığı alanın yüzde 60'ı
          minChildSize: 0.2, // Minimum kapladığı alanın yüzde 20'si
          maxChildSize: 0.8, // Maksimum kapladığı alanın yüzde 80'i

          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Color(0xFFDFD0B8),
              child: FutureBuilder<List<Favoriler>>(
                future: favroileriGoster(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Hata: ${snapshot.error}'),
                    );
                  } else {
                    List<Favoriler>? favorilerListesi = snapshot.data;
                    if (favorilerListesi == null || favorilerListesi.isEmpty) {
                      return Center(
                        child: Text('Favori film bulunamadı.'),
                      );
                    } else {
                      return ListView.builder(
                        controller: scrollController,
                        itemCount: favorilerListesi.length,
                        itemBuilder: (context, index) {
                          Favoriler favori = favorilerListesi[index];
                          return InkWell(
                            onTap: () {
                              // Favoriye tıklama işlemi
                            },
                            child: Dismissible(
                              key: UniqueKey(),
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                Favorilerdao().favoriSil(favori.id);
                                setState(() {
                                  favorilerListesi.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${favori.film_ad} favorilerden kaldırıldı.'),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 80,
                                child: Card(
                                  child: GestureDetector(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(favori.film_ad),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );


                    }
                  }
                },
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF153448),
        centerTitle: true,
        title: const Text("Filmler Uygulaması", style: TextStyle(color: Color(0xFFDFD0B8), fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.favorite, color: Color(0xFFDFD0B8),
          ),
          onPressed: () {
            _showDraggableBottomSheet(context);
          },
        ),
      ),
      body: Container(
        color: Color(0xFF3C5B6F),
        child: FutureBuilder<List<Kategoriler>>(
          future: tumKategorileriGoster(),
          builder: (context,snapshot) {
            if(snapshot.hasData){
              var kategoriListesi = snapshot.data;
              return ListView.builder(
                  itemCount: kategoriListesi!.length,
                  itemBuilder: (context,index){
                    var kategori = kategoriListesi[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FilmlerSayfa(kategori: kategori,)));
                      },
                      child: Card(
                        color: Color(0xFFDFD0B8),
                        child: SizedBox(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(kategori.kategori_ad,style: TextStyle(fontWeight: FontWeight.w500),),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );
            }else{
              return Center();
            }  //else
          },
        ),
      ),
    );
  }
}
