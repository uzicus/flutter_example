import 'package:flutter/material.dart';
import 'package:flutter_app/entity/project.dart';
import 'package:flutter_app/localization.dart';
import 'package:flutter_app/ui/projects/projects_bloc.dart';
import 'package:flutter_app/ui/widgets/container_scroll_view.dart';

class ProjectsScreen extends StatefulWidget {
  final _projectsBloc = ProjectsBloc();

  @override
  State<StatefulWidget> createState() => _ProjectsState();
}

class _ProjectsState extends State<ProjectsScreen> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    widget._projectsBloc.fetchProjects();

    return Scaffold(
      appBar: AppBar(
        title: Text(Localization
            .of(context)
            .projectsTitle),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: widget._projectsBloc.fetchProjects,
        child: StreamBuilder(
          stream: widget._projectsBloc.projects,
          builder: (context, AsyncSnapshot<List<Project>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isNotEmpty) {
                return _buildProjectList(snapshot.data);
              } else {
                return ContainerScrollView(
                    child: Center(
                      child: Text(Localization
                          .of(context)
                          .projectsEmptyTitle),
                    )
                );
              }
            } else if (snapshot.hasError) {
              return ContainerScrollView(
                  child: Center(
                    child: Text(snapshot.error.toString()),
                  )
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildProjectList(List<Project> projects) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        var item = projects[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: _buildProjectItem(item),
        );
      },
    );
  }

  Widget _buildProjectItem(Project project) {
    return  Card(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsetsDirectional.only(end: 16),
                child: Image.network(project.iconUrl, width: 64,),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        project.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Text(
                      project.description,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget._projectsBloc.dispose();
    super.dispose();
  }
}
