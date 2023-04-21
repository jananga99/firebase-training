class Note {
  final String title;
  final String description;
  final String email;

  Note(this.title, this.description, this.email);

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'email': email,
    };
  }
}
