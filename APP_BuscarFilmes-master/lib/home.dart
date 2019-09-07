import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_admob/firebase_admob.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var ano = new TextEditingController();
  var titulo = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 120,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(
              Icons.live_tv,
              size: 200,
              color: Colors.deepPurpleAccent,
            ),
            Padding(padding: EdgeInsets.only(bottom: 30)),
            TextField(
              controller: ano,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Ano do Lançamento (opcional)',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            TextField(
              controller: titulo,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Nome do Filme*',
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 60,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Filme(
                              titulo: titulo.text,
                              ano: ano.text,
                            ),
                          ));
                    },
                    child: Text(
                      'Buscar',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    color: Colors.deepPurpleAccent,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

//SEGUNDA TELA
class Filme extends StatefulWidget {
  Future<Map> getData() async {
    var request = "http://www.omdbapi.com/?t=$titulo&y=$ano&apikey=bfc23be5";

    var resposta = await http.get(request);

    print(resposta.body);

    if (resposta.statusCode == 200) {
      return json.decode(resposta.body);
    } else {
      throw Exception(
        Center(
          child: Text(
            "Filme não encontrado...",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 45.0,
                color: Colors.amber),
          ),
        ),
      );
    }
  }

  final String titulo;
  final String ano;

  Filme({Key key, @required this.titulo, @required this.ano}) : super(key: key);

  @override
  _FilmeState createState() => _FilmeState();
}

class _FilmeState extends State<Filme> {
  MobileAdTargetingInfo targetingInfo;
  BannerAd myBanner;
  @override
  void initState() {
    super.initState();
    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      birthday: DateTime.now(),
      childDirected: false,
      designedForFamilies: false,
      gender: MobileAdGender
          .male, // or MobileAdGender.female, MobileAdGender.unknown
      testDevices: <String>[], // Android emulators are considered test devices
    );
    myBanner = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  void _show_banner() {
    myBanner
      // typically this happens well before the ad is shown
      ..load()
      ..show(
          // Positions the banner ad 60 pixels from the bottom of the screen

          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: FutureBuilder(
        future: widget.getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: Text(
                  "Carregando...",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35.0,
                      color: Colors.deepPurpleAccent),
                ),
              );
              break;
            default:
              if (snapshot.hasData) {
                return Scaffold(
                  backgroundColor: Colors.black45,
                  body: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      top: 70,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          snapshot.data['Title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40.0,
                              color: Colors.white),
                        ),
                        Text(
                          '(' + snapshot.data['Year'] + ')',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 25.0,
                              color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.0),
                        ),
                        Image.network(
                          snapshot.data['Poster'],
                          width: 300,
                          height: 430,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Data de lançamento: ',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: snapshot.data['Released'],
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Duração: ',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: snapshot.data['Runtime'],
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Genêro: ',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          snapshot.data['Genre'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Sinopse: ',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          snapshot.data['Plot'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.white),
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Tipo: ',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: snapshot.data['Type'],
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Diretor: ',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: snapshot.data['Director'],
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 50.0),
                        ),
                        RaisedButton(
                          onPressed: _show_banner,
                          child: Text('Dinheiro'),
                        )
                      ],
                    ),
                  ),
                );
                //enviar o snapshot como parametro para inicial e fazer a busca; lá do Widget
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "O filme não foi encontrado!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.0,
                        color: Colors.greenAccent),
                  ),
                );
              } else {
                return Center(
                  child: Text("Erro na conexão."),
                );
              }
          }
        },
      ),
    );
  }
}
