import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/models/project_model.dart';

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
    );
    await projectRef.set(projectModel.toMap());
    return projectModel;
  }
}
