import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final String title;
  final String description;
  final String email;
  final DateTime createdAt;
  final String? id;

  const Note({
    this.id,
    required this.title,
    required this.description,
    required this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toFirebase() {
    return {
      'title': title,
      'description': description,
      'email': email,
      'createdAt': createdAt
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

  @override
  List<Object?> get props => [id, title, description, email, createdAt];
}
