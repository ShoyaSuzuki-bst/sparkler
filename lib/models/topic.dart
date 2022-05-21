class Topic {
  String id = '';
  String title = '';
  String content = '';
  DateTime createdAt = DateTime(0);

  Topic(
    String id,
    String title,
    String content,
    DateTime createdAt,
  );

  static Topic create(String _id, String _title, String _content) {
    return Topic(
      "",
      "",
      "",
      DateTime.now(),
    );
  }

  static List<Topic> where() {
    return [];
  }

  static Topic find() {
    return Topic(
      "",
      "",
      "",
      DateTime.now(),
    );
  }

  Topic update(String _id, String _title, String _content) {
    return Topic(
      "",
      "",
      "",
      DateTime.now(),
    );
  }
}
