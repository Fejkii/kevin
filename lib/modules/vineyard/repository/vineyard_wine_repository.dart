import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/modules/vineyard/model/vineyard_wine_summary_model.dart';

import '../../../const/app_collections.dart';
import '../model/vineyard_wine_model.dart';

class VineyardWineRepository {
  CollectionReference<Map<String, dynamic>> _getVineyardWineRef(String vineyardId) {
    return FirebaseFirestore.instance.collection(AppCollection.vineards).doc(vineyardId).collection(AppCollection.vineardWines);
  }

  Future<void> createVineyardWine(String vineyardId, VineyardWineModel vineyardWineModel) async {
    final vineyardRef = _getVineyardWineRef(vineyardId).doc();
    vineyardWineModel.id = vineyardRef.id;
    await vineyardRef.set(vineyardWineModel.toMap());
  }

  Future<void> updateVineyardWine(String vineyardId, VineyardWineModel vineyardWineModel) async {
    await _getVineyardWineRef(vineyardId).doc(vineyardWineModel.id).set(vineyardWineModel.toMap());
  }

  Future<List<VineyardWineModel>> getVineyardWineList(String vineyardId) async {
    List<VineyardWineModel> list = [];
    await _getVineyardWineRef(vineyardId).get().then((value) {
      for (var element in value.docs) {
        list.add(VineyardWineModel.fromMap(element.data()));
      }
    });
    return list;
  }

  Future<VineyardWineSummaryModel> getVineyardWineSummary(String vineyardId) async {
    final count = await _getVineyardWineRef(vineyardId).count().get();
    late int quantitySum = 0;
    await _getVineyardWineRef(vineyardId).get().then((value) {
      for (var element in value.docs) {
        quantitySum += (VineyardWineModel.fromMap(element.data())).quantity;
      }
    });
    return VineyardWineSummaryModel(count: count.count, quantitySum: quantitySum);
  }
}
