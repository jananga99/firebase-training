class Note {
  final String title;
  final String description;
  final String email;
  final DateTime createdAt;

  Note({
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

  static Note fromFirebase(Map<String, dynamic> data) {
    return Note(
        title: data['title'],
        description: data['description'],
        email: data['email'],
        createdAt: data['createdAt'].toDate());
  }
}
