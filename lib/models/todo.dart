class Todo {
  final int id;
  final String title;
  final String description;
  final bool isChecked;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isChecked,
  });

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? isChecked,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isChecked: json['isChecked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isChecked': isChecked,
    };
  }
}
