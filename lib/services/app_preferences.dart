import 'dart:convert';

import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/repository/wine_classification_repository.dart';
import 'package:kevin/services/language_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';

import '../modules/project/data/model/user_project_model.dart';

enum AppPreferencesKeys {
  language,
  user,
  userProject,
  wineClassification,
}

class AppPreferences {
  final WineClassificationRepository wineClassificationRepository = WineClassificationRepository();
  late SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<SharedPreferences> initSP() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
  }

  String getAppLanguage() {
    String? language = _sharedPreferences.getString(AppPreferencesKeys.language.name);
    if (language != null && language.isNotEmpty) {
      return language;
    } else {
      return LanguageCodeEnum.czech.getValue();
    }
  }

  Future<void> setAppLanguage(String language) async {
    await _sharedPreferences.setString(AppPreferencesKeys.language.name, language);
  }

  Future<void> clear() async {
    await _sharedPreferences.clear();
  }

  Future<void> logout() async {
    await _sharedPreferences.remove(AppPreferencesKeys.user.name);
  }

  bool isUserLoggedIn() {
    return _sharedPreferences.getString(AppPreferencesKeys.user.name) != null &&
            _sharedPreferences.getString(AppPreferencesKeys.user.name)!.isNotEmpty
        ? true
        : false;
  }

  Future<void> setUser(UserModel user) async {
    await _sharedPreferences.setString(AppPreferencesKeys.user.name, user.toJson());
  }

  UserModel getUser() {
    return UserModel.fromJson(_sharedPreferences.getString(AppPreferencesKeys.user.name) ?? "");
  }

  Future<void> setUserProject(UserProjectModel userProject) async {
    await _sharedPreferences.setString(AppPreferencesKeys.userProject.name, userProject.toJson());
  }

  bool hasUserProject() {
    return _sharedPreferences.getString(AppPreferencesKeys.userProject.name) != null ? true : false;
  }

  UserProjectModel getUserProject() {
    return UserProjectModel.fromJson(_sharedPreferences.getString(AppPreferencesKeys.userProject.name)!);
  }

  Future<void> setWineClassifications(List<WineClassificationModel> wineClassificationList) async {
    var wineClassifications = jsonEncode(wineClassificationList);
    await _sharedPreferences.setString(AppPreferencesKeys.wineClassification.name, wineClassifications);
  }

  List<WineClassificationModel> getWineClassificationList() {
    List<WineClassificationModel> wineClassificationList = [];
    (jsonDecode(_sharedPreferences.getString(AppPreferencesKeys.wineClassification.name)!)).forEach((element) {
      wineClassificationList.add(WineClassificationModel.fromJson(element));
    });
    return wineClassificationList;
  }
}
