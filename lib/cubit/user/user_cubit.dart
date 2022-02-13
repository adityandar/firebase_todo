import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_todo/repository/auth/auth_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthRepository _authRepository;
  UserCubit(this._authRepository) : super(LoggedOutUserState());

  void register(String email, String password) async {
    emit(LoadingRegisterUserState());
    try {
      User? user = await _authRepository.register(email, password);
      if (user != null) {
        emit(SuccessUserState(user: user));
      }
    } catch (e) {
      String msg = "";
      msg = e.toString().replaceAll("Exception", "Error");
      emit(FailureUserState(errorMessage: msg));
    }
  }

  void login(String email, String password) async {
    emit(LoadingLoginUserState());
    try {
      User? user = await _authRepository.signIn(email, password);
      if (user != null) {
        emit(SuccessUserState(user: user));
      }
    } catch (e) {
      String msg = "";
      msg = e.toString().replaceAll("Exception", "Error");
      emit(FailureUserState(errorMessage: msg));
    }
  }

  void logout() {
    emit(LoadingLoginUserState());
    _authRepository.signOut();
    emit(InitialUserState());
  }

  void onAuthChanges() {
    _authRepository.checkAuth().listen((user) {
      emit(LoadingLoginUserState());
      if (user != null) {
        emit(LoggedInUserState(user: user));
      } else {
        emit(LoggedOutUserState());
      }
    });
  }
}
