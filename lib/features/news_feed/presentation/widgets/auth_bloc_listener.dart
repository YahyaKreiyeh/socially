import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socially/core/extenstions/extensions.dart';
import 'package:socially/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:socially/routing/routes.dart';

class AuthBlocListener extends StatelessWidget {
  const AuthBlocListener({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state == const SignOutSuccess()) {
          context.pushNamedAndRemoveUntil(
            Routes.signinPage,
            predicate: (s) => false,
          );
        }
      },
      child: Container(),
    );
  }
}
