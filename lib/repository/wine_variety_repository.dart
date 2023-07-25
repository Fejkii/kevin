import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/models/wine_variety_model.dart';

class WineVarietyRepository {
  final firebase = FirebaseFirestore.instance.collection(AppCollection.wineVarieties);
  
  Stream<List<WineVarietyModel>> getAllWineVarieties() {
    return firebase.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => WineVarietyModel.fromMap(doc.data())).toList();
    });
  }

  Future<void> createWineVariety(String title, String code) async {
    final wineVarietyRef = firebase.doc();
    final wineVarietyModel = WineVarietyModel(
      id: wineVarietyRef.id,
      title: title,
      code: code,
    );
    await wineVarietyRef.set(wineVarietyModel.toMap());
  }

  Future<void> updateWineVariety(WineVarietyModel wineVarietyModel) async {
    await firebase.doc(wineVarietyModel.id).set(wineVarietyModel.toMap());
  }
}
