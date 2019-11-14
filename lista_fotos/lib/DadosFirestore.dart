import 'package:cloud_firestore/cloud_firestore.dart';

class DadosFirestore {
  Firestore firestore;

  DadosFirestore() {
    firestore = Firestore.instance;
  }

  Future<List> getDadosFirestore() async{
    QuerySnapshot snapshot = await firestore.collection("fotos_salvas").getDocuments();
    List<DocumentSnapshot> doc = snapshot.documents;
    return doc;
  }

}