abstract class AuthEvent {}

class CheckLoginStatus extends AuthEvent {}
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final String role;

  LoginRequested(this.email, this.password, this.role);
}