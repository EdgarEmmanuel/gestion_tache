class Task {
  final int id;
  final String title;
  final String description;
  final DateTime date_echeance;

  const Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.date_echeance});

  // factory Task.fromJson(Map<String, dynamic> json) {
  //   return Task(
  //     id: json['id'],
  //     title: json['title'],
  //   );
  // }
}
