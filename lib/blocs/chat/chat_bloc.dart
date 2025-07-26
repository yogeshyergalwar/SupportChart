import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/api_service.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ApiService apiService;
  ChatBloc(this.apiService) : super(ChatInitial()) {
    on<LoadChats>((event, emit) async {
      emit(ChatLoading());
      try {
        final chats = await apiService.getChats(event.userId);
        emit(ChatLoaded(chats));
      } catch (e) {
        emit(ChatError('Failed to load chats'));
      }
    });
  }
}