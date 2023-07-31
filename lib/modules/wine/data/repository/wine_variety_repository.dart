import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kevin/const/app_collections.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

class WineVarietyRepository {
  final firebase = FirebaseFirestore.instance
      .collection(AppCollection.projects)
      .doc(instance<AppPreferences>().getUserProject().project.id)
      .collection(AppCollection.wineVarieties);

  Stream<List<WineVarietyModel>> getAllWineVarieties() {
    return firebase.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => WineVarietyModel.fromMap(doc.data())).toList();
    });
  }

  Future<List<WineVarietyModel>> getWineVarietyList() async {
    List<WineVarietyModel> list = [];
    await firebase.get().then((value) async {
      for (var element in value.docs) {
        list.add(WineVarietyModel.fromMap(element.data()));
      }
    });

    return list;
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
