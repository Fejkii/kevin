import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';
import 'package:kevin/modules/project/data/repository/project_repository.dart';
import 'package:kevin/modules/auth/data/repository/user_repository.dart';

import '../model/user_project_entity.dart';
import '../model/project_model.dart';
import '../model/user_project_model.dart';

class UserProjectRepository {
  final firebase = FirebaseFirestore.instance.collection(AppCollection.userProjects);
  final ProjectRepository projectRepository = ProjectRepository();
  final UserRepository userRepository = UserRepository();

  Future<List<UserProjectModel>> getUserProjectListByProject(String projectId) async {
    List<UserProjectModel> list = [];
    late ProjectModel projectModel;
    late UserModel userModel;
    await firebase.where("projectId", isEqualTo: projectId).get().then((value) async {
      for (var element in value.docs) {
        UserProjectEntity userProjectEntity = UserProjectEntity.fromMap(element.data());
        projectModel = await projectRepository.getProject(userProjectEntity.projectId);
        userModel = await userRepository.getUser(userProjectEntity.userId);

        list.add(UserProjectModel(
          id: userProjectEntity.id,
          user: userModel,
          project: projectModel,
          isDefault: userProjectEntity.isDefault,
          isOwner: userProjectEntity.isOwner,
          created: userProjectEntity.created,
          updated: userProjectEntity.updated,
        ));
      }
    });

    return list;
  }

  Future<List<UserProjectModel>> getUserProjectListByUser(String userId) async {
    List<UserProjectModel> list = [];
    late ProjectModel projectModel;
    late UserModel userModel;
    await firebase.where("userId", isEqualTo: userId).get().then((value) async {
      for (var element in value.docs) {
        UserProjectEntity userProjectEntity = UserProjectEntity.fromMap(element.data());
        projectModel = await projectRepository.getProject(userProjectEntity.projectId);
        userModel = await userRepository.getUser(userProjectEntity.userId);

        list.add(UserProjectModel(
          id: userProjectEntity.id,
          user: userModel,
          project: projectModel,
          isDefault: userProjectEntity.isDefault,
          isOwner: userProjectEntity.isOwner,
          created: userProjectEntity.created,
          updated: userProjectEntity.updated,
        ));
      }
    });

    return list;
  }

  Future<UserProjectModel?> getDefaultUserProject(String userId) async {
    late ProjectModel projectModel;
    late UserModel userModel;
    UserProjectModel? userProjectModel;
    await firebase.where("userId", isEqualTo: userId).where("isDefault", isEqualTo: true).get().then((value) async {
      for (var element in value.docs) {
        if (value.docs.isNotEmpty) {
          final userProjectEntity = UserProjectEntity.fromMap(element.data());
          projectModel = await projectRepository.getProject(userProjectEntity.projectId);
          userModel = await userRepository.getUser(userProjectEntity.userId);

          userProjectModel = UserProjectModel(
            id: userProjectEntity.id,
            user: userModel,
            project: projectModel,
            isDefault: userProjectEntity.isDefault,
            isOwner: userProjectEntity.isOwner,
            created: userProjectEntity.created,
            updated: userProjectEntity.updated,
          );
        } else {
          userProjectModel = null;
        }
      }
    });
    return userProjectModel;
  }

  Future<UserProjectModel> createUserProject(
    UserModel userModel,
    ProjectModel projectModel,
    bool isDefault,
    bool isOwner,
  ) async {
    UserProjectModel userProjectModel;

    if (isDefault) {
      await firebase.where("userId", isEqualTo: userModel.id).get().then((value) async {
        for (var element in value.docs) {
          UserProjectEntity userProject = UserProjectEntity.fromMap(element.data());
          userProject.isDefault = false;
          userProject.updated = DateTime.now();
          await firebase.doc(userProject.id).set(userProject.toMap());
        }
      });
    }
    final userProjectRef = firebase.doc();

    userProjectModel = UserProjectModel(
      id: userProjectRef.id,
      user: userModel,
      project: projectModel,
      isDefault: isDefault,
      isOwner: isOwner,
      created: DateTime.now(),
      updated: DateTime.now(),
    );

    userProjectRef.set(
      UserProjectEntity(
        id: userProjectRef.id,
        userId: userProjectModel.user.id,
        projectId: projectModel.id,
        isDefault: userProjectModel.isDefault,
        isOwner: userProjectModel.isOwner,
        created: userProjectModel.created,
        updated: userProjectModel.updated,
      ).toMap(),
    );
    return userProjectModel;
  }

  Future<UserProjectModel> setProjectDefault(UserModel userModel, UserProjectModel userProjectModel) async {
    userProjectModel.isDefault = true;
    userProjectModel.updated = DateTime.now();
    await firebase.where("userId", isEqualTo: userModel.id).get().then((value) async {
      for (var element in value.docs) {
        UserProjectEntity userProject = UserProjectEntity.fromMap(element.data());
        if (userProject.id == userProjectModel.id) {
          userProject.isDefault = true;
          userProject.updated = userProjectModel.updated;
          await firebase.doc(userProject.id).set(userProject.toMap());
        } else {
          userProject.isDefault = false;
          userProject.updated = DateTime.now();
          await firebase.doc(userProject.id).set(userProject.toMap());
        }
      }
    });
    return userProjectModel;
  }

  Future<void> deleteUserFromProject(UserProjectModel userProjectModel) async {
    await firebase.doc(userProjectModel.id).delete();
  }
}
