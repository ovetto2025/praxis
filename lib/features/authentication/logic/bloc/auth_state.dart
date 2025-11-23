import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? userId;
  final String? error;

  const AuthState({this.status = AuthStatus.unknown, this.userId, this.error});

  AuthState copyWith({AuthStatus? status, String? userId, String? error}) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, userId, error];
}

const AuthState unknownState = AuthState(status: AuthStatus.unknown);
const AuthState unauthenticatedState = AuthState(
  status: AuthStatus.unauthenticated,
);
