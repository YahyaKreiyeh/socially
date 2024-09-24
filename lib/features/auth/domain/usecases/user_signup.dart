import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/entities/user.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/auth/domain/repository/auth_repository.dart';

class UserSignup implements UseCase<User, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignup(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
    return await authRepository.signupWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String password;
  final String name;
  UserSignUpParams({
    required this.email,
    required this.password,
    required this.name,
  });
}
