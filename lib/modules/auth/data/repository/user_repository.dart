import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';

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

  Future<UserModel> createUser(String userId, String name, String email) async {
    UserModel userModel = UserModel(userId, email, name, DateTime.now(), DateTime.now());
    await firebase.doc(userId).set(userModel.toMap());
    return userModel;
  }

  Future<UserModel> createUserName(UserModel userModel, String name) async {
    await firebase.doc(userModel.id).set(
          UserModel(
            userModel.id,
            userModel.email,
            name,
            userModel.created,
            DateTime.now(),
          ).toMap(),
        );

    return userModel;
  }

  Future<void> updateUser(UserModel userModel) async {
    await firebase.doc(userModel.id).set(userModel.toMap());
  }
}
