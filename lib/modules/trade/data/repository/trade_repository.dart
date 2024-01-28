import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/modules/trade/data/model/trade_model.dart';

import '../../../../const/app_collections.dart';
import '../../../../services/app_preferences.dart';
import '../../../../services/dependency_injection.dart';

class TradeRepository {
  final firebase = FirebaseFirestore.instance
      .collection(AppCollection.projects)
      .doc(instance<AppPreferences>().getUserProject().project.id)
      .collection(AppCollection.trades);

  Future<void> createTrade(TradeModel tradeModel) async {
    final purchaseRef = firebase.doc();
    tradeModel.id = purchaseRef.id;

    await purchaseRef.set(tradeModel.toMap());
  }

  Future<void> updateTrade(TradeModel tradeModel) async {
    await firebase.doc(tradeModel.id).set(tradeModel.toMap());
  }

  Future<List<TradeModel>> getTradeList(TradeType tradeType) async {
    List<TradeModel> list = [];
    if (tradeType == TradeType.all) {
      await firebase.orderBy("date", descending: true).get().then((value) {
        for (var element in value.docs) {
          list.add(TradeModel.fromMap(element.data()));
        }
      });
    } else {
      await firebase.where("tradeTypeId", isEqualTo: tradeType.getId()).get().then((value) {
        for (var element in value.docs) {
          list.add(TradeModel.fromMap(element.data()));
        }
      });
    }
    return list;
  }
}
