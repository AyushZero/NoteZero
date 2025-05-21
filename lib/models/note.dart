import 'package:uuid/uuid.dart';

class Note {
  final String id;
  String title;
  String content;
  DateTime createdAt;
  DateTime modifiedAt;
  bool isDeleted;

  Note({
    String? id,
    required this.title,
    required this.content,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.isDeleted = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'isDeleted': isDeleted,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      isDeleted: json['isDeleted'] ?? false,
    );
  }
} 