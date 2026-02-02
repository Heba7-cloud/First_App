class MessageModel {
  int? id;
  String content;
  int chatId; // الربط مع جدول المحادثات

  MessageModel({this.id, required this.content, required this.chatId});

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      content: map['content'],
      chatId: map['chat_id'],
    );
  }
}