
import 'package:flutter_app/api/api.dart';
import 'package:flutter_app/entity/project.dart';

class ProjectsModel {

  Future<List<Project>> getProjects() => Api.fetchProjects();

}