import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/modules/vineyard/model/vineyard_model.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

import '../../../const/app_collections.dart';

class VineyardRepository {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final firebase = FirebaseFirestore.instance.collection(AppCollection.vineards);

  Future<void> createVineyard(VineyardModel vineyardModel) async {
    final vineyardRef = firebase.doc();
    vineyardModel.id = vineyardRef.id;
    await vineyardRef.set(vineyardModel.toMap());
  }

  Future<void> updateVineyard(VineyardModel vineyardModel) async {
    await firebase.doc(vineyardModel.id).set(vineyardModel.toMap());
  }

  Future<VineyardModel> getVineyard(String vineyardId) async {
    late VineyardModel vineyard;
    await firebase.doc(vineyardId).get().then((value) => vineyard = VineyardModel.fromMap(value.data()!));
    return vineyard;
  }

  Future<List<VineyardModel>> getVineyarList() async {
    List<VineyardModel> list = [];
    await firebase.where("projectId", isEqualTo: appPreferences.getUserProject().project.id).get().then((value) {
      for (var element in value.docs) {
        list.add(VineyardModel.fromMap(element.data()));
      }
    });
    return list;
  }
}
