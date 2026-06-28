class Task {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String dueDate;
  final String status;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? 'Pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'status': status,
    };
  }
}
