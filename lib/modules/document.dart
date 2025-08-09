class Document {
  final String id;
  final String title;
  final String content;
  final DateTime? createdAt;

  Document({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory Document.fromMap(Map<dynamic, dynamic> map) {
    return Document(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      createdAt:
          map['createdAt'] != null
              ? DateTime.parse(map['createdAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
