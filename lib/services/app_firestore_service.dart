import 'package:cloud_firestore/cloud_firestore.dart';

class AppFirestoreService {
  final firebaseInstace = FirebaseFirestore.instance;

  Future<DocumentReference> createData(String collection, Map<String, dynamic> data) async {
    // ignore: body_might_complete_normally_catch_error
    return await firebaseInstace.collection(collection).add(data).then((docRef) => docRef).catchError((error) {
      // ignore: avoid_print
      print("Error adding document: $error");
    });
  }

  DocumentReference createDoc(String collection) {
    return firebaseInstace.collection(collection).doc();
  }

  Future<void> updateDoc(String collection, String docId, Map<String, dynamic> data) async {
    return await firebaseInstace.collection(collection).doc(docId).set(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getList(String collection) {
    return firebaseInstace.collection(collection).get();
  }
}
