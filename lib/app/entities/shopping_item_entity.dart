class ShoppingItemEntity {
  String? id;
  String title;
  DateTime createdAt;
  bool isCompleted;

  ShoppingItemEntity({
    required this.title,
    this.id,
    required this.createdAt,
    this.isCompleted = false,
  });

  ShoppingItemEntity copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    bool? isCompleted,
  }) {
    return ShoppingItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ShoppingItemEntity.fromMap(Map<String, dynamic> map) {
    return ShoppingItemEntity(
      id: map['id'],
      title: map['title'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      isCompleted: map['isCompleted'],
    );
  }
}
