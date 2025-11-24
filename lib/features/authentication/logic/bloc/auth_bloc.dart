import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:praxis/features/authentication/data/auth_repository.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late final StreamSubscription<User?> _userSub;

  AuthBloc({required this.authRepository}) : super(unknownState) {
    on<AuthUserChanged>(_onAuthUserChanged);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthOnboardingCompleted>(_onOnboardingCompleted);
    on<AuthCarouselCompleted>(_onCarouselCompleted);

    _userSub = authRepository.user.listen((user) {
      add(AuthUserChanged(user?.uid));
    });
  }

  Future<void> _onAuthUserChanged(
    AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.userId != null) {
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          userId: event.userId,
          error: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          userId: null,
          error: null,
        ),
      );
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final user = await authRepository.signUp(
        event.email,
        event.password,
        displayName: '${event.firstName.trim()} ${event.lastName.trim()}'
            .trim(),
      );
      if (user == null) {
        emit(
          state.copyWith(
            status: AuthStatus.failure,
            error: 'Registrazione fallita.',
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final user = await authRepository.signIn(event.email, event.password);
      if (user == null) {
        emit(
          state.copyWith(status: AuthStatus.failure, error: 'Login fallita.'),
        );
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authRepository.signOut();
  }

  Future<void> _onOnboardingCompleted(
    AuthOnboardingCompleted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(hasSeenOnboarding: true));
  }

  Future<void> _onCarouselCompleted(
    AuthCarouselCompleted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isCarouselDone: true));
  }

  @override
  Future<void> close() {
    _userSub.cancel();
    return super.close();
  }
}
