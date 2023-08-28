class TodoModel {
  final int? id;
  final String? title;
  final String? dis;
  final String? datetime;

  TodoModel({this.id, this.title, this.dis, this.datetime});

  TodoModel.fromMap(Map<String, dynamic> res) :
      id = res['id'],
  title = res['title'],
  dis = res['dis'],
  datetime = res['datetime'];

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "title":title,
      "dis" : dis,
      "datetime":datetime,
    };
  }
}
