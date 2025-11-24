import 'package:equatable/equatable.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, loading, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? userId;
  final String? error;
  final bool hasSeenOnboarding;
  final bool isCarouselDone;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.userId,
    this.error,
    this.hasSeenOnboarding = false,
    this.isCarouselDone = false,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? error,
    bool? hasSeenOnboarding,
    bool? isCarouselDone,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      error: error,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      isCarouselDone: isCarouselDone ?? this.isCarouselDone,
    );
  }

  @override
  List<Object?> get props => [
    status,
    userId,
    error,
    hasSeenOnboarding,
    isCarouselDone,
  ];
}

const AuthState unknownState = AuthState(status: AuthStatus.unknown);
const AuthState unauthenticatedState = AuthState(
  status: AuthStatus.unauthenticated,
);
