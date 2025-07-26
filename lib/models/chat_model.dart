class ChatModel {
  final String id;
  final bool isGroupChat;

  ChatModel({
    required this.id,
    required this.isGroupChat,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      isGroupChat: json['isGroupChat'],
    );
  }
}
