class ToDo {
  String? id;
  String? todoText;
  String? date;
  bool isDone;
  bool isUrgent;
  bool isUnimportant;

  ToDo({
    required this.id,
    required this.todoText,
    this.date,
    this.isDone = false,
    this.isUrgent = false,
    this.isUnimportant = false,
  });
}
