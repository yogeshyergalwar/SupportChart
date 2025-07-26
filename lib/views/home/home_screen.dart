import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_service.dart';
import '../../models/chat_model.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatModel> chats = [];
  void loadChats() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? '';  // 🔍 check if stored
      print('Loading chats for user: $userId');

      final chatList = await ApiService().getChats(userId);
      setState(() {
        chats = chatList;
      });
    } catch (e) {
      print('Error loading chats: $e');
    }
  }




  @override
  void initState() {
    super.initState();
    loadChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            title: Text("Chat: ${chat.id}"),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatScreen(chatId: chat.id),
            )),
          );
        },
      ),
    );
  }
}
