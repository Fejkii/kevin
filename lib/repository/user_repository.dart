import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/models/user_model.dart';

class UserRepository {
  final firebase = FirebaseFirestore.instance.collection(AppCollection.users);

  Future<UserModel> getUser(String userId) async {
    late UserModel userModel;
    await firebase.doc(userId).get().then((value) {
      userModel = UserModel.fromMap(value.data()!);
    });
    return userModel;
  }

  Future<UserModel?> getUserByEmail(String email) async {
    late UserModel? userModel;
    userModel = null;
    await firebase.where("email", isEqualTo: email).get().then((value) {
      for (var element in value.docs) {
        userModel = UserModel.fromMap(element.data());
      }
    });
    return userModel;
  }
}
