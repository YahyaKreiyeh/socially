import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/usecase/usecase.dart';
import 'package:socially/core/error/failures.dart';
import 'package:socially/features/auth/domain/repository/auth_repository.dart';

class UserSignout implements UseCase<bool, NoParams> {
  final AuthRepository authRepository;
  const UserSignout(this.authRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await authRepository.signout();
  }
}
