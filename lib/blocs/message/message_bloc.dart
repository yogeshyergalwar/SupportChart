import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/api_service.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ApiService apiService;

  MessageBloc(this.apiService) : super(MessageInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(MessageLoading());
      try {
        final messages = await apiService.getChatMessages(event.chatId);
        emit(MessageLoaded(messages));
      } catch (e) {
        emit(MessageError('Failed to load messages'));
      }
    });

    on<SendMessageEvent>((event, emit) async {
      try {
        final success = await apiService.sendMessage(
            event.chatId, event.senderId, event.content);
        if (success) {
          final updatedMessages =
              await apiService.getChatMessages(event.chatId);
          emit(MessageLoaded(updatedMessages)); // Refresh list
        } else {
          emit(MessageError('Failed to send message'));
        }
      } catch (e) {
        emit(MessageError('Error sending message'));
      }
    });
  }
}
