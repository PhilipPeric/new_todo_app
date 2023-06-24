class ToDo {
  String? id;
  String? todoText;
  DateTime? deadline;
  bool isDone;
  bool isUrgent;
  bool isUnimportant;
  final DateTime createdAt;
  final DateTime changedAt;
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

  ToDo copyWith({
    String? id,
    String? todoText,
    DateTime? deadline,
    bool? isDone,
    bool? isUrgent,
    bool? isUnimportant,
    DateTime? createdAt,
    DateTime? changedAt,
    String? lastUpdatedBy,
  }) {
    return ToDo(
      createdAt ?? this.createdAt,
      changedAt ?? this.changedAt,
      lastUpdatedBy,
      id: id ?? this.id,
      todoText: todoText ?? this.todoText,
      deadline: deadline ?? this.deadline,
      isDone: isDone ?? this.isDone,
      isUrgent: isUrgent ?? this.isUrgent,
      isUnimportant: isUnimportant ?? this.isUnimportant,
    );
  }

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
