import 'package:kevin/models/user_project_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kevin/models/user_model.dart';

enum AppPreferencesKeys {
  user,
  userProject,
}

class AppPreferences {
  late SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<SharedPreferences> initSP() async {
    return _sharedPreferences = await SharedPreferences.getInstance();
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

  UserModel? getUser() {
    if (_sharedPreferences.getString(AppPreferencesKeys.user.name) != null) {
      return UserModel.fromJson(_sharedPreferences.getString(AppPreferencesKeys.user.name)!);
    }
    return null;
  }

  Future<void> setUserProject(UserProjectModel userProject) async {
    await _sharedPreferences.setString(AppPreferencesKeys.userProject.name, userProject.toJson());
  }

  bool hasUserProject() {
    return _sharedPreferences.getString(AppPreferencesKeys.userProject.name) != null ? true : false;
  }

  UserProjectModel? getUserProject() {
    if (_sharedPreferences.getString(AppPreferencesKeys.userProject.name) != null) {
      return UserProjectModel.fromJson(_sharedPreferences.getString(AppPreferencesKeys.userProject.name)!);
    }
    return null;
  }
}
