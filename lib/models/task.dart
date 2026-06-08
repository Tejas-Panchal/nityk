class Task {
  final int? id;
  final String title;
  final String? description;
  final int priority;
  final bool isCompleted;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime? completedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.priority = 2,
    this.isCompleted = false,
    this.dueDate,
    DateTime? createdAt,
    this.completedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'priority': priority,
    'is_completed': isCompleted ? 1 : 0,
    'due_date': dueDate?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
  };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
    id: map['id'] as int?,
    title: map['title'] as String,
    description: map['description'] as String?,
    priority: map['priority'] as int? ?? 2,
    isCompleted: (map['is_completed'] as int?) == 1,
    dueDate: map['due_date'] != null
        ? DateTime.parse(map['due_date'] as String)
        : null,
    createdAt: DateTime.parse(map['created_at'] as String),
    completedAt: map['completed_at'] != null
        ? DateTime.parse(map['completed_at'] as String)
        : null,
  );

  Task copyWith({
    int? id,
    String? title,
    String? description,
    int? priority,
    bool? isCompleted,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? completedAt,
  }) => Task(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    priority: priority ?? this.priority,
    isCompleted: isCompleted ?? this.isCompleted,
    dueDate: dueDate ?? this.dueDate,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt ?? this.completedAt,
  );
}
