class MessageModel {
  final String senderId;
  final String content;
  final String messageType;

  MessageModel({
    required this.senderId,
    required this.content,
    required this.messageType,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      content: json['content'],
      messageType: json['messageType'],
    );
  }
}
