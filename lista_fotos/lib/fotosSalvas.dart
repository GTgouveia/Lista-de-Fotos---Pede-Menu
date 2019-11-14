
import 'package:flutter/material.dart';
import 'package:lista_fotos/DadosFirestore.dart';
import 'package:lista_fotos/DeleteDadosFirestore.dart';

void main() async{

  runApp(MaterialApp(
    home: ListaFotos(),
  ));
}

class ListaFotos extends StatefulWidget {
  
  @override
  _ListaFotosState createState() => _ListaFotosState();

}

class _ListaFotosState extends State<ListaFotos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title:Text(
          "Fotos Salvas - Firebase",
        ),
        centerTitle: true,
      ),
      body: ListaSalvos(),
    );
  }
}

Widget ListaSalvos(){
  int _lastIdRemovedPos;

  return FutureBuilder<List>(
    future: DadosFirestore().getDadosFirestore(),
    builder: (context,snapshot){
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

                if(snapshot.data.length <= 0){
                  return Center(
                          child: Text(
                            "Não há dados salvos...",
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
                            return Dismissible(
                              key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
                              background: Container(
                                color: Colors.red,
                                child: Align(
                                  alignment: Alignment(-0.9,0.0),
                                  child: Icon(Icons.delete, color: Colors.white,),
                                ),
                              ),
                              direction: DismissDirection.startToEnd,
                              child: GestureDetector(
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
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                  "Arraste para a esquerda para remover o item",
                                                    style: TextStyle(
                                                      fontSize: 10.0,
                                                      color: Colors.red
                                                    ),
                                                  ),
                                                  Icon(Icons.arrow_right),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            onDismissed: (direction){
                              
                              _lastIdRemovedPos = snapshot.data[index]["id"];
                              print(_lastIdRemovedPos);
                              
                              DeleteDadosFirestore().deleteDados(_lastIdRemovedPos);

                              final snack = SnackBar(
                                content: Text(
                                  "Imagem numero $_lastIdRemovedPos removida!",
                                ),
                                duration: Duration(
                                  seconds: 2
                                ),
                              );
                              Scaffold.of(context).showSnackBar(snack);
                            },
                            );
                          },
                        );
                }
              
              }
          }
    },
  );
}

/*

*/
