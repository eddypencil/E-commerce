import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/auth/domain/Entites.dart';
import 'package:e_commerce/features/auth/domain/useCases.dart';
import 'package:equatable/equatable.dart';
import 'package:e_commerce/core/injection/get_It.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final CheckifLoginUseCase _checkifLoginUseCase;

  AuthCubit()
      : _loginUseCase = getIt<LoginUseCase>(),
        _checkifLoginUseCase = getIt<CheckifLoginUseCase>(),
        super(AuthInitial());

  void login(Map<String, dynamic> credentials) async {
    emit(AuthLoading());

    final userdata = await _loginUseCase(credentials);
    userdata.fold(
      (fail) => emit(AuthError(error: fail.error)),
      (user) => emit(AuthLoaded(user: user)),
    );
    log("auth cubit============$userdata");
  }

  void checkIfLogged() async {
    emit(AuthLoading());
    final accessToken = await getIt<FlutterSecureStorage>().read(key: "accessToken");
    final result = await _checkifLoginUseCase({
      'Authorization': "'Bearer $accessToken'"

    }); // or pass data if required
    result.fold(
      (fail) => emit(AuthError(error: fail.error)),
      (user) => emit(AuthLoaded(user: user)),
    );
  }
}
