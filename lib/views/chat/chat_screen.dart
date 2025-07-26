import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/message/message_bloc.dart';
import '../../blocs/message/message_event.dart';
import '../../blocs/message/message_state.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String senderId = '';

  @override
  void initState() {
    super.initState();
    _loadSenderId();
    context.read<MessageBloc>().add(LoadMessages(widget.chatId));
  }

  Future<void> _loadSenderId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    senderId = prefs.getString("userId") ?? '';
  }

  void sendMessage() {
    final content = controller.text.trim();
    if (content.isEmpty || senderId.isEmpty) return;

    context.read<MessageBloc>().add(
          SendMessageEvent(widget.chatId, senderId, content),
        );
    controller.clear();
  }

  Widget buildMessageBubble(MessageModel msg, bool isSender, bool isLast) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFFFFD9B3) : Colors.white,

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isSender ? 12 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 12),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.content,
              style: TextStyle(
                fontSize: 15,
                color: isSender ? const Color(0xFF333333) : Colors.black,
              ),
            ),

            const SizedBox(height: 4),
            Text("From: ${msg.senderId}",
                style: TextStyle(fontSize: 10, color: Colors.grey[900])),
            if (isLast && isSender)
              const Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 4.0),
                  child: Text("Seen",
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ),
              )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfa6404),
        title: const Text("Chat", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessageLoaded) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController
                          .jumpTo(_scrollController.position.maxScrollExtent);
                    }
                  });

                  if (state.messages.isEmpty) {
                    return const Center(child: Text("No messages"));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final msg = state.messages[index];
                      final isSender = msg.senderId == senderId;
                      final isLast = index == state.messages.length - 1;
                      return buildMessageBubble(msg, isSender, isLast);
                    },
                  );
                } else if (state is MessageError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("No messages"));
                }
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Type a message",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFFfa6404)),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
