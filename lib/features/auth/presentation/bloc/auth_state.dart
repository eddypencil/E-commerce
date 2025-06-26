part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoaded extends AuthState {
  final UserEntity user;

  const AuthLoaded({required this.user});
  @override
  List<Object> get props => [user];
}

final class AuthError extends AuthState {
  final String error;

  const AuthError({required this.error});
  @override
  List<Object> get props => [error];
}