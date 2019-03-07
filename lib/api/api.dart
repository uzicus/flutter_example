import 'package:flutter/foundation.dart';
import 'package:flutter_app/entity/project.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const baseUrl = "https://gist.githubusercontent.com/uzicus/32f399a749fb8d818c50da362e98129d/raw";

class Api {

  static Future<List<Project>> fetchProjects() async {
    final response = await http.get("$baseUrl/fake_data");

    if (response.statusCode == 200) {
      return compute(_parseProjects, response.body);
    } else {
      throw Exception("Failed to load projects");
    }
  }

  static List<Project> _parseProjects(String responseBody) {
    Map<String, dynamic> parsed = json.decode(responseBody);
    Iterable projects = parsed["projects"];

    return projects.map(Project.fromJson).toList();
  }
}