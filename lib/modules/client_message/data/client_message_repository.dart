import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/modules/client_message/data/client_message_model.dart';

class ClientMessageRepository {
  final firebase = FirebaseFirestore.instance.collection(AppCollection.clientMessages);

  Future<void> createMessage(ClientMessageModel clientMessageModel) async {
    final clientMessageRef = firebase.doc();
    clientMessageModel.id = clientMessageRef.id;

    await clientMessageRef.set(clientMessageModel.toMap());
  }
}
