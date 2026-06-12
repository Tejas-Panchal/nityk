class Category {
  final int? id;
  final String name;
  final int color;
  final int sortOrder;

  const Category({
    this.id,
    required this.name,
    this.color = 0xFF2196F3,
    this.sortOrder = 0,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'color': color,
    'sort_order': sortOrder,
  };

  factory Category.fromMap(Map<String, dynamic> map) => Category(
    id: map['id'] as int?,
    name: map['name'] as String,
    color: map['color'] as int,
    sortOrder: map['sort_order'] as int? ?? 0,
  );
}
