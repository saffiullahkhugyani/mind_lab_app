class Item {
  final int subscription;
  final Profile profile;
  final Project project;

  Item({
    required this.subscription,
    required this.profile,
    required this.project,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      subscription: json['subscription'],
      profile: Profile.fromJson(json['profiles']),
      project: Project.fromJson(json['projects']),
    );
  }
}

class Profile {
  final String id;
  final String name;

  Profile({
    required this.id,
    required this.name,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Project {
  final int id;
  final String name;

  Project({
    required this.id,
    required this.name,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
    );
  }
}
