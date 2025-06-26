import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/auth/domain/Entites.dart';

import 'Repos.dart';

class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(
      Map<String, dynamic> data) async {
    return await authRepo.getUser(data);
  }

  
}


class CheckifLoginUseCase {
  final AuthRepo authRepo;

  CheckifLoginUseCase({required this.authRepo});

  Future<Either<Failure, UserEntity>> call(
      Map<String, dynamic> data) async {
    return await authRepo.getAuthUser(data);
  }

  
}

