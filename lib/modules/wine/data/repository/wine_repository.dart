import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

class WineRepository {
  final firebase = FirebaseFirestore.instance.collection(AppCollection.wines);
  final AppPreferences appPreferences = instance<AppPreferences>();

  Stream<List<WineModel>> getAllWines() {
    return firebase.where("projectId", isEqualTo: appPreferences.getUserProject().project.id).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => WineModel.fromMap(doc.data())).toList();
    });
  }

  Future<void> createWine(
    String title,
    List<WineVarietyModel> wineVarieties,
    WineClassificationModel? wineClassification,
    double quantity,
    int year,
    double? alcohol,
    double? acid,
    double? sugar,
    String? note,
  ) async {
    final wineRef = firebase.doc();
    final wineModel = WineModel(
      id: wineRef.id,
      projectId: appPreferences.getUserProject().project.id,
      wineVarieties: wineVarieties,
      title: title,
      quantity: quantity,
      year: year,
      alcohol: alcohol,
      acid: acid,
      sugar: sugar,
      note: note,
      created: DateTime.now(),
    );
    await wineRef.set(wineModel.toMap());
  }

  Future<void> updateWine(WineModel wineModel) async {
    await firebase.doc(wineModel.id).set(wineModel.toMap());
  }
}
