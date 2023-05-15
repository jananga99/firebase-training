import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String title;
  final String description;
  final String email;
  final DateTime? createdAt;
  final String? id;

  const Note({
    this.id,
    required this.title,
    required this.description,
    required this.email,
    this.createdAt,
  });

  Map<String, dynamic> toFirebase() {
    return {
      'title': title,
      'description': description,
      'email': email,
      'createdAt': createdAt ?? DateTime.now()
    };
  }

  static Note fromFirebase(String id, Map<String, dynamic> data) {
    return Note(
        id: id,
        title: data['title'],
        description: data['description'],
        email: data['email'],
        createdAt: data['createdAt'].toDate());
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        email: json['email'],
        createdAt: DateTime.parse(json['createdAt']));
  }

  Note copyWith(
      {String? id,
      String? title,
      String? description,
      String? email,
      DateTime? createdAt}) {
    return Note(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt);
  }

  @override
  List<Object?> get props => [id, title, description, email, createdAt];
}
