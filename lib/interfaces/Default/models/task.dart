class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime date_echeance;

  const Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.date_echeance});

  @override
  String toString() {
    return " title = " + this.title;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    var millis = 978296400000;
    return Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date_echeance: DateTime.parse(json['date_echeance_second']));
  }
}
