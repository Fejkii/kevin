import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';

import '../model/project_model.dart';

class ProjectRepository {
  final firebase = FirebaseFirestore.instance.collection(AppCollection.projects);

  Future<ProjectModel> getProject(String projectId) async {
    late ProjectModel projectModel;
    await firebase.doc(projectId).get().then((value) {
      projectModel = ProjectModel.fromMap(value.data()!);
    });
    return projectModel;
  }

  Future<ProjectModel> createProject(String title) async {
    late ProjectModel projectModel;
    final projectRef = firebase.doc();
    projectModel = ProjectModel(
      id: projectRef.id,
      title: title,
      defaultFreeSulfur: 40,
      defaultLiquidSulfur: 15,
    );
    await projectRef.set(projectModel.toMap());
    return projectModel;
  }

  Future<void> updateProject(ProjectModel projectModel) async {
    await firebase.doc(projectModel.id).set(projectModel.toMap());
  }
}
