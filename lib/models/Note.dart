class Note {
  final String title;
  final String description;
  final String email;
  final DateTime createdAt;

  Note(
      {required this.title,
      required this.description,
      required this.email,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'email': email,
      'createdAt': createdAt
    };
  }
}
