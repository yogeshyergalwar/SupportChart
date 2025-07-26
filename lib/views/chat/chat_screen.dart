import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_service.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  List<MessageModel> messages = [];

  void loadMessages() async {
    final api = ApiService();
    final msgs = await api.getChatMessages(widget.chatId);
    setState(() => messages = msgs);
  }

  void sendMessage() async {
    final prefs = await SharedPreferences.getInstance();
    final senderId = prefs.getString("userId")!;
    final content = controller.text.trim();

    if (content.isEmpty) return;

    final success = await ApiService().sendMessage(widget.chatId, senderId, content);
    if (success) {
      controller.clear();
      loadMessages();
    }
  }

  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  title: Text(msg.content),
                  subtitle: Text(msg.senderId),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: controller, decoration: const InputDecoration(hintText: "Type a message"))),
                IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
