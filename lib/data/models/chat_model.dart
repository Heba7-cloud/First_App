class ChatModel {
  int? id;
  String title;
  int userId; // الربط مع جدول المستخدمين

  ChatModel({this.id, required this.title, required this.userId});

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      title: map['title'],
      userId: map['user_id'],
    );
  }
}