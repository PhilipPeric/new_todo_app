class ToDo {
  String? id;
  String? todoText;
  DateTime? deadline;
  bool isDone;
  bool isUrgent;
  bool isUnimportant;
  final DateTime createdAt;
  DateTime changedAt;
  final String? lastUpdatedBy;

  ToDo(
    this.createdAt,
    this.changedAt,
    this.lastUpdatedBy, {
    required this.id,
    required this.todoText,
    this.deadline,
    this.isDone = false,
    this.isUrgent = false,
    this.isUnimportant = false,
  });

  static ToDo fromJson(Map<String, dynamic> todo) {
    return ToDo(
      todo['created_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(todo['created_at'])
          : DateTime.now(),
      todo['changed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(todo['changed_at'])
          : DateTime.now(),
      todo['last_updated_by'],
      id: todo['id'],
      todoText: todo['text'],
      isDone: todo['done'],
      isUrgent: todo['importance'] == 'important',
      isUnimportant: todo['low'] == 'low',
      deadline: todo['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(todo['deadline'])
          : null,
    );
  }

  toJson() {
    return {
      'id': id,
      'text': todoText,
      'importance': isUrgent
          ? 'important'
          : isUnimportant
              ? 'low'
              : 'basic',
      'done': isDone,
      'created_at': createdAt.millisecondsSinceEpoch,
      'changed_at': changedAt.millisecondsSinceEpoch,
      'last_updated_by': lastUpdatedBy,
      'deadline': deadline?.millisecondsSinceEpoch,
    };
  }
}
