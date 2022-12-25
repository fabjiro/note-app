class Note {
  int? id;
  String title;
  String content;
  int color;
  DateTime date;

  Note({
    this.id,
    required this.color,
    required this.content,
    required this.title,
    required this.date,
  });

  Note.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        content = res['content'],
        color = res['color'],
        date = DateTime.parse(res['date']);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'date': date.toString(),
    };
  }
}
