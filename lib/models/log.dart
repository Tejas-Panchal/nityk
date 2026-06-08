class Log {
  final int? id;
  final String title;
  final String description;
  final String date;
  final DateTime? startedAt;
  final DateTime? finishedAt;
  final int? durationSeconds;
  final int? taskId;
  final int? habitId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Log({
    this.id,
    required this.title,
    this.description = '',
    required this.date,
    this.startedAt,
    this.finishedAt,
    this.durationSeconds,
    this.taskId,
    this.habitId,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'title': title,
    'description': description,
    'date': date,
    'started_at': startedAt?.toIso8601String(),
    'finished_at': finishedAt?.toIso8601String(),
    'duration_seconds': durationSeconds,
    'task_id': taskId,
    'habit_id': habitId,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Log.fromMap(Map<String, dynamic> map) => Log(
    id: map['id'] as int?,
    title: map['title'] as String,
    description: (map['description'] as String?) ?? '',
    date: map['date'] as String,
    startedAt: map['started_at'] != null
        ? DateTime.parse(map['started_at'] as String)
        : null,
    finishedAt: map['finished_at'] != null
        ? DateTime.parse(map['finished_at'] as String)
        : null,
    durationSeconds: map['duration_seconds'] as int?,
    taskId: map['task_id'] as int?,
    habitId: map['habit_id'] as int?,
    createdAt: DateTime.parse(map['created_at'] as String),
    updatedAt: DateTime.parse(map['updated_at'] as String),
  );

  Log copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    DateTime? startedAt,
    DateTime? finishedAt,
    int? durationSeconds,
    int? taskId,
    int? habitId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearStartedAt = false,
    bool clearFinishedAt = false,
    bool clearDuration = false,
  }) => Log(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    date: date ?? this.date,
    startedAt: clearStartedAt ? null : (startedAt ?? this.startedAt),
    finishedAt: clearFinishedAt ? null : (finishedAt ?? this.finishedAt),
    durationSeconds: clearDuration
        ? null
        : (durationSeconds ?? this.durationSeconds),
    taskId: taskId ?? this.taskId,
    habitId: habitId ?? this.habitId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
