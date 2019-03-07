
import 'package:flutter_app/entity/project.dart';
import 'package:flutter_app/model/projects_model.dart';
import 'package:rxdart/rxdart.dart';

class ProjectsBloc {
  final _projectsModel = ProjectsModel();

  final _projectsFetcher = PublishSubject<List<Project>>();

  Observable<List<Project>> get projects => _projectsFetcher.stream;

  Future fetchProjects() async {
    await _projectsModel.getProjects().then(
        _projectsFetcher.sink.add,
        onError: _projectsFetcher.sink.addError
    );
  }

  dispose() {
    _projectsFetcher.close();
  }

}