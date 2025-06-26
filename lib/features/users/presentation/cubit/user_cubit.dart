// user_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:e_commerce/features/users/data/user_data_source.dart';

import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRemoteDataSource userRemoteDataSource;

  UserCubit(this.userRemoteDataSource) : super(UserInitial());

  Future<void> fetchUser() async {
    emit(UserLoading());
    try {
      final user = await userRemoteDataSource.getUser();
      emit(UserLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
