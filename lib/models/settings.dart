class Settings {
  final String sortOrder;
  final bool darkMode;
  final bool use24h;

  const Settings({
    this.sortOrder = 'New->Old',
    this.darkMode = true,
    this.use24h = true,
  });

  Map<String, dynamic> toMap() => {
    'sort_order': sortOrder,
    'dark_mode': darkMode ? 1 : 0,
    'use_24h': use24h ? 1 : 0,
  };

  factory Settings.fromMap(Map<String, dynamic> map) => Settings(
    sortOrder: map['sort_order'] as String? ?? 'New->Old',
    darkMode: (map['dark_mode'] as int?) == 1,
    use24h: (map['use_24h'] as int?) == 1,
  );

  Settings copyWith({String? sortOrder, bool? darkMode, bool? use24h}) =>
      Settings(
        sortOrder: sortOrder ?? this.sortOrder,
        darkMode: darkMode ?? this.darkMode,
        use24h: use24h ?? this.use24h,
      );
}
