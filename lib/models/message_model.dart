class MessageModel {
  final String id;
  final DateTime createdAt;
  final String userId;
  final String mood;
  final String content;

  MessageModel({
    required this.id,
    required this.createdAt,
    required this.userId,
    required this.mood,
    required this.content,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
      mood: json['mood'],
      content: json['content'],
    );
  }
}
