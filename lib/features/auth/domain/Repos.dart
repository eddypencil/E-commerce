import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/auth/domain/Entites.dart';

abstract class AuthRepo {
  Future<Either<Failure,UserEntity>> getUser(Map<String,dynamic> data);
   Future<Either<Failure,UserEntity>> getAuthUser(Map<String,dynamic> data);

}