part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignUp extends AuthEvent {
  final String email;
  final String password;
  final String name;

  AuthSignUp({
    required this.email,
    required this.password,
    required this.name,
  });
}

final class AuthSignin extends AuthEvent {
  final String email;
  final String password;

  AuthSignin({
    required this.email,
    required this.password,
  });
}

final class AuthIsUserLoggedIn extends AuthEvent {}

final class AuthSignOut extends AuthEvent {}
