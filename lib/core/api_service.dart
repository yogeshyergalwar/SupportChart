import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ApiService {
  static const String baseUrl = 'http://45.129.87.38:6065';

  Future<UserModel?> login(String email, String password, String role) async {
    final url = Uri.parse('$baseUrl/user/login');
    final response = await http.post(url, body: {
      'email': email,
      'password': password,
      'role': role,
    });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final userJson = jsonData['data']['user'];
      final token = jsonData['data']['token'];
      return UserModel.fromJson(userJson, token);
    } else {
      return null;
    }
  }

  Future<List<ChatModel>> getChats(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/chats/user-chats/$userId'));

    print("Chat API Response: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> chatList = jsonDecode(response.body);
      return chatList.map((chat) => ChatModel.fromJson(chat)).toList();
    } else {
      throw Exception('Failed to load chats');
    }
  }

  Future<List<MessageModel>> getChatMessages(String chatId) async {
    final url = Uri.parse('$baseUrl/messages/get-messagesformobile/$chatId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => MessageModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<bool> sendMessage(
      String chatId, String senderId, String content) async {
    final url = Uri.parse('$baseUrl/messages/sendMessage');
    final response = await http.post(url, body: {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'messageType': 'text',
      'fileUrl': ''
    });

    print('SEND MESSAGE RESPONSE: ${response.statusCode}');
    print('SEND MESSAGE BODY: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
