import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteDadosFirestore {
  Firestore firestore;

  DeleteDadosFirestore() {
    firestore = Firestore.instance;
  }

  void deleteDados(int index) async{
    firestore.collection("fotos_salvas").document("foto$index").delete();
  }

}
