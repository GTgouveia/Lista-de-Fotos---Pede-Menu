import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SalvarDadosAPI {
  Firestore firestore;

  SalvarDadosAPI() {
    firestore = Firestore.instance;
  }

  

  Future<void> salvarDados(dynamic data) async {
    int id = data["id"];

    final QuerySnapshot result = await firestore.collection("fotos_salvas").where(
      "id",
      isEqualTo: id,
    ).limit(1).getDocuments();

    final List<DocumentSnapshot> documents = result.documents;

    if(documents.length == 1){
        return SnackBar(
          content: Text(
            "A foto de numero $id já está salvo!"
          ),
        );
    }else{
      await firestore.collection("fotos_salvas").document("foto$id")
        .setData({
          "albumId":data["albumId"],
          "id":data["id"],
          "title":data["title"],
          "url":data["url"],
          "thumbnailUrl":data["thumbnailUrl"],
        });
    }

  }

}

/*
await firestore.collection("fotos_salvas").document("foto$id")
      .setData({
      "albumId":data["albumId"],
      "id":data["id"],
      "title":data["title"],
      "url":data["url"],
      "thumbnailUrl":data["thumbnailUrl"],
      }); 
*/

