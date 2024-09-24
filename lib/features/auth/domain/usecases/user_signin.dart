import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/entities/user.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/auth/domain/repository/auth_repository.dart';

class UserSignin implements UseCase<User, UserSigninParams> {
  final AuthRepository authRepository;
  const UserSignin(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSigninParams params) async {
    return await authRepository.signinWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserSigninParams {
  final String email;
  final String password;

  UserSigninParams({
    required this.email,
    required this.password,
  });
}
