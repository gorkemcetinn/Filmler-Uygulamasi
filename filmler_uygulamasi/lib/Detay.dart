import 'package:flutter/material.dart';

class Detay extends StatefulWidget {
  const Detay({super.key});

  @override
  State<Detay> createState() => _DetayState();
}

class _DetayState extends State<Detay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Film İsmi", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900,
        ),
        ),
      ),
      body: Container(
        color: Color(0xFFED1250),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

            ],
          ),
        ),
      ),
    );
  }
}
