class Allergic{
  int? id;
  String title;
  String description;
  DateTime created;

  Allergic({
    this.id,
    required this.title,
    required this.description,
    required this.created
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created': created.toIso8601String(),
    };
  }

  factory Allergic.fromMap(Map<String, dynamic> map) {
    return Allergic(
      id: map['id'] as int?,
      title: map['title'],
      description: map['description'],
      created: DateTime.parse(map['created']),
    );
  }

}