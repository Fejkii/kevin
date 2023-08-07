import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/modules/vineyard/model/vineyard_record_model.dart';

import '../../../const/app_collections.dart';

class VineyardRecordRepository {
  CollectionReference<Map<String, dynamic>> _getVineyardRecordRef(String vineyardId) {
    return FirebaseFirestore.instance.collection(AppCollection.vineards).doc(vineyardId).collection(AppCollection.vineardRecords);
  }

  Future<void> createVineyardRecord(String vineyardId, VineyardRecordModel vineyardRecordModel) async {
    final vineyardRecordRef = _getVineyardRecordRef(vineyardId).doc();
    vineyardRecordModel.id = vineyardRecordRef.id;
    await vineyardRecordRef.set(vineyardRecordModel.toMap());
  }

  Future<void> updateVineyardRecord(String vineyardId, VineyardRecordModel vineyardWineModel) async {
    await _getVineyardRecordRef(vineyardId).doc(vineyardWineModel.id).set(vineyardWineModel.toMap());
  }

  Future<List<VineyardRecordModel>> getVineyardRecordList(String vineyardId) async {
    List<VineyardRecordModel> list = [];
    await _getVineyardRecordRef(vineyardId).orderBy("date", descending: true).get().then((value) {
      for (var element in value.docs) {
        list.add(VineyardRecordModel.fromMap(element.data()));
      }
    });
    return list;
  }
}
