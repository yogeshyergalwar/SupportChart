abstract class MessageEvent {}

class LoadMessages extends MessageEvent {
  final String chatId;
  LoadMessages(this.chatId);
}

class SendMessageEvent extends MessageEvent {
  final String chatId;
  final String senderId;
  final String content;
  SendMessageEvent(this.chatId, this.senderId, this.content);
}
