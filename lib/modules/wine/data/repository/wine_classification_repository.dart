import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';

class WineClassificationRepository {
  final firebase = FirebaseFirestore.instance.collection(AppCollection.wineClassifications);

  Future<List<WineClassificationModel>> getWineClassificationList() async {
    List<WineClassificationModel> list = [];
    await firebase.get().then((value) async {
      for (var element in value.docs) {
        list.add(WineClassificationModel.fromMap(element.data()));
      }
    });

    return list;
  }
}
