import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent {
  final String? userId;
  AuthUserChanged(this.userId);
  @override
  List<Object?> get props => [userId];
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  AuthSignInRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthSignOutRequested extends AuthEvent {}
