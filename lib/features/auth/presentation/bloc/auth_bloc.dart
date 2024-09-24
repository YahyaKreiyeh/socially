import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socially/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:socially/core/common/entities/user.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/features/auth/domain/usecases/current_user.dart';
import 'package:socially/features/auth/domain/usecases/user_signin.dart';
import 'package:socially/features/auth/domain/usecases/user_signout.dart';
import 'package:socially/features/auth/domain/usecases/user_signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignup _userSignUp;
  final UserSignin _userSignin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserBloc;
  final UserSignout _userSignOut;
  AuthBloc({
    required UserSignup userSignUp,
    required UserSignin userSignin,
    required CurrentUser currentUser,
    required AppUserCubit appUserBloc,
    required UserSignout userSignOut,
  })  : _userSignUp = userSignUp,
        _userSignin = userSignin,
        _currentUser = currentUser,
        _appUserBloc = appUserBloc,
        _userSignOut = userSignOut,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthSignin>(_onAuthSignin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthSignOut>(_onAuthSignOut);
  }

  void _isUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignOut(NoParams());
    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(const SignOutSuccess()),
    );
  }

  void _onAuthSignUp(
    AuthSignUp event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onAuthSignin(
    AuthSignin event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignin(
      UserSigninParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(
    User user,
    Emitter<AuthState> emit,
  ) {
    _appUserBloc.updateUser(user);
    emit(AuthSuccess(user));
  }
}
