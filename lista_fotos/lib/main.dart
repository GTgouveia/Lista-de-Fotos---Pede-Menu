import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lista_fotos/salvarDados.dart';
import 'dart:async';
import 'dart:convert';
import 'fotosSalvas.dart';

const request = "https://jsonplaceholder.typicode.com/photos/";

void main() async{

  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Imagens"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ListaFotos()),
          );
        },
        child:Icon(Icons.save),
        backgroundColor: Colors.red,
        
      ),
      body: FutureBuilder<List>(
      future: getData(),
      builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando dados...",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            default:
              if (snapshot.hasError) {
               return Center(
                child: Text(
                  "Erro ao carregar dados :(",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ); 
              }else{
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: <Widget>[
                              Image.network(
                                snapshot.data[index]["url"],
                                width: 80.0,
                                height: 80.0,
                              ),
                              Expanded(
                                child: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index]["title"],
                                        style: TextStyle(
                                          fontSize: 15.0
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        _showOptions(context,snapshot.data[index]);
                      },
                    );
                  },
                );
              }
          }
      }
    ),
    );
  }
}

void _showOptions(BuildContext context, dynamic data){
  showModalBottomSheet(
    context: context,
    builder: (context){
      return BottomSheet(
        onClosing: (){},
        builder: (context){
          return Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Salvar",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: () async{
                    SalvarDadosAPI salvarDadosAPI = SalvarDadosAPI();
                    salvarDadosAPI.salvarDados(data);
                  },
                ),
              ],
            ),  
          );
        },
      );
    },
  );
}

Future<List> getData() async{
  http.Response response = await http.get(request);
  List<dynamic> data = json.decode(response.body);
  return data;
}
