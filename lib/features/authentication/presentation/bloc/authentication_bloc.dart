import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:praxis/data/repository/auth_repository.dart';

import '../../../../data/models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository authRepository = AuthRepository();
  AuthenticationBloc() : super(AuthenticationInitialState()) {
    on<AuthenticationEvent>((event, emit) {});
    on<SignUpUser>((event, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        final UserModel? user = await authRepository.signUp(
          event.email,
          event.password,
        );
        if (user != null) {
          emit(AuthenticationSuccessState(user));
        } else {
          emit(const AuthenticationFailureState('create user failed'));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });

    on<SignOut>((evnt, emit) async {
      emit(AuthenticationLoadingState(isLoading: true));
      try {
        authRepository.signOut();
      } catch (e) {
        debugPrint('error');
        debugPrint(e.toString());
      }
      emit(AuthenticationLoadingState(isLoading: false));
    });
  }
}
