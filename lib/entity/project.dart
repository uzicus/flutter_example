
class Project {
  String name;
  String description;
  String iconUrl;

  Project({this.name, this.description, this.iconUrl});

  static Project fromJson(dynamic json) => Project(
      name: json['name'],
      description: json['description'],
      iconUrl: json['icon_url']
  );
}
