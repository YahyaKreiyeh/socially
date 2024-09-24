import 'package:fpdart/fpdart.dart';
import 'package:socially/core/common/entities/user.dart';
import 'package:socially/core/error/failures.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signupWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> signinWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> currentUser();
  Future<Either<Failure, bool>> signout();
}
