import 'package:filmler_uygulamasi/Favoriler.dart';
import 'package:filmler_uygulamasi/Favorilerdao.dart';
import 'package:filmler_uygulamasi/Filmler.dart';
import 'package:filmler_uygulamasi/Filmlerdao.dart';
import 'package:filmler_uygulamasi/Kategoriler.dart';
import 'package:flutter/material.dart';

class FilmlerSayfa extends StatefulWidget {
  late Kategoriler kategori;
  FilmlerSayfa({required this.kategori});

  @override
  State<FilmlerSayfa> createState() => _FilmlerSayfaState();
}

class _FilmlerSayfaState extends State<FilmlerSayfa> {
  late List<Favoriler> favorilerListesi;

  @override
  void initState() {
    super.initState();
    _getFavoriler();
  }

  Future<void> _getFavoriler() async {
    favorilerListesi = await Favorilerdao().tumFavorileriGetir();
    setState(() {});
  }

  Future<List<Filmler>> filmleriGoster(int kategori_id) async {
    var filmlerListesi = await Filmlerdao().tumFilmlerByKategoriId(kategori_id);
    return filmlerListesi;
  }

  Future<void> favoriKayit(int film_id, String film_ad) async {
    var isFavori = favorilerListesi.any((favori) => favori.film_id == film_id);
    if (!isFavori) {
      await Favorilerdao().favoriKaydet(film_id, film_ad);
      _getFavoriler(); // Favorileri yeniden getir
      _showSnackBar(film_ad);
    } else {
      _showSnackBar(film_ad);
    }
  }

  void _showSnackBar(String film_ad) {
    var isFavori = favorilerListesi.any((favori) => favori.film_id == film_idi);
    if (isFavori) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bu film zaten favorilerinizde!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Favorilere eklendi: $film_ad'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  bool isFavori(int film_id) {
    return favorilerListesi.any((favori) => favori.film_id == film_id);
  }

  late String film_adi;
  late int film_idi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF153448),
        centerTitle: true,
        title: Text(
          widget.kategori.kategori_ad,
          style: TextStyle(
            color: Color(0xFFDFD0B8),
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Color(0xFFDFD0B8),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Color(0xFF3C5B6F),
        child: FutureBuilder<List<Filmler>>(
          future: filmleriGoster(widget.kategori.kategori_id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var filmlerListesi = snapshot.data;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 3.5,
                ),
                itemCount: filmlerListesi!.length,
                itemBuilder: (context, index) {
                  var film = filmlerListesi[index];
                  return Card(
                    color: Color(0xFFDFD0B8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            "resimler/${film.film_resim}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            film.film_ad,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: IconButton(
                            onPressed: () {
                              film_adi = film.film_ad;
                              film_idi = film.film_id;
                              favoriKayit(film_idi, film_adi);
                            },
                            icon: Icon(
                              Icons.favorite_border,
                              color: isFavori(film.film_id) ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              return Center();
            } //else
          },
        ),
      ),
    );
  }
}
