import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/modules/wine/data/model/wine_record_model.dart';

import '../../../../const/app_collections.dart';
import '../../../../services/app_preferences.dart';
import '../../../../services/dependency_injection.dart';

class WineRecordRepository {
  final AppPreferences appPreferences = instance<AppPreferences>();

  CollectionReference<Map<String, dynamic>> _getWineRecordRef(String wineId) {
    return FirebaseFirestore.instance.collection(AppCollection.wines).doc(wineId).collection(AppCollection.wineRecords);
  }

  Future<void> createWineRecord(String wineId, WineRecordModel wineRecordModel) async {
    final wineRecordRef = _getWineRecordRef(wineId).doc();
    wineRecordModel.id = wineRecordRef.id;
    await wineRecordRef.set(wineRecordModel.toMap());
  }

  Future<List<WineRecordModel>> getWineRecordList(String wineId) async {
    List<WineRecordModel> list = [];
    await _getWineRecordRef(wineId).get().then((value) {
      for (var element in value.docs) {
        list.add(WineRecordModel.fromMap(element.data()));
      }
    });
    return list;
  }

  Future<void> updateWineRecord(String wineId, WineRecordModel wineRecordModel) async {
    await _getWineRecordRef(wineId).doc(wineRecordModel.id).set(wineRecordModel.toMap());
  }
}
