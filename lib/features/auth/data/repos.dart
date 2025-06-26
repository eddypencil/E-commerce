import 'package:dartz/dartz.dart';
import 'package:e_commerce/core/failure.dart';
import 'package:e_commerce/features/auth/domain/Entites.dart';
import 'package:e_commerce/features/auth/domain/Repos.dart';
import 'DataSources.dart';
import 'package:e_commerce/core/network/Exceptions/exceptions.dart';

class AuthRepoImpl extends AuthRepo {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;

  AuthRepoImpl({required this.authenticationRemoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> getUser(Map<String, dynamic> data) async {
    try {
      final userData = await authenticationRemoteDataSource.loginUser(data);
      return Right(UserEntity(
        id: userData.id,
        username: userData.username,
        email: userData.email,
        firstname: userData.firstname,
        lastname: userData.lastname,
        gender: userData.gender,
        image: userData.image,
      ));
    } on BadRequestException catch (e) {
      return Left(Failure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(Failure(e.message));
    } on NotFoundException {
      return Left(Failure('Not Found'));
    } on ServerErrorException {
      return Left(Failure('Server error, try again later'));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getAuthUser(
      Map<String, dynamic> data) async {
    try {
      final userData = await authenticationRemoteDataSource.checkIfloginUser(data);
      return Right(UserEntity(
        id: userData.id,
        username: userData.username,
        email: userData.email,
        firstname: userData.firstname,
        lastname: userData.lastname,
        gender: userData.gender,
        image: userData.image,
      ));
    } on BadRequestException catch (e) {
      return Left(Failure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(Failure(e.message));
    } on NotFoundException {
      return Left(Failure('Not Found'));
    } on ServerErrorException {
      return Left(Failure('Server error, try again later'));
    } catch (e) {
      return Left(Failure('Unexpected error: ${e.toString()}'));
    }
  }
}
