import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/chat/chat_event.dart';
import '../../blocs/chat/chat_state.dart';
import '../chat/chat_screen.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String userRole = 'vendor'; // default

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadChats();
  }

  void _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? 'vendor';
    });
  }


  void _loadChats() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId') ?? '';

     final role = prefs.getString('role') ?? '';
     print('4R${role}');
    context.read<ChatBloc>().add(LoadChats(userId));
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfa6404),
        title: Text(userRole == 'vendor' ? "Vendor Chat" : "Customer Chat",style: TextStyle( color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatLoaded) {
            if (state.chats.isEmpty) {
              return const Center(child: Text("No chats available"));
            }

            return ListView.separated(
              itemCount: state.chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = state.chats[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueGrey[100],
                    child: Text(chat.id.substring(0, 2).toUpperCase()),
                  ),
                  title: Text("${chat.id}"),
                  subtitle: const Text("Tap to continue conversation"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(chatId: chat.id),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No chats available"));
          }
        },
      ),
    );
  }
}
