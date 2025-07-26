import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/api_service.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc(this.apiService) : super(AuthInitial()) {
    on<CheckLoginStatus>((event, emit) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      if (token != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnauthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      final user =
          await apiService.login(event.email, event.password, event.role);
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", user.token);
        prefs.setString("userId", user.id);
        prefs.setString("role", user.role);
        emit(AuthAuthenticated());
      } else {
        emit(AuthFailure());
      }
    });
  }
}
