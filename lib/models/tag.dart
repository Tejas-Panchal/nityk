class Tag {
  final int? id;
  final String name;
  final int categoryId;
  final int sortOrder;

  const Tag({
    this.id,
    required this.name,
    required this.categoryId,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'category_id': categoryId,
    'sort_order': sortOrder,
  };

  factory Tag.fromMap(Map<String, dynamic> map) => Tag(
    id: map['id'] as int?,
    name: map['name'] as String,
    categoryId: map['category_id'] as int,
    sortOrder: map['sort_order'] as int? ?? 0,
  );
}
