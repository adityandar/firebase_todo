import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_todo/services/auth_service.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthService _authService;
  UserCubit(this._authService) : super(InitialUserState());

  void register(String email, String password) async {
    emit(LoadingRegisterUserState());
    try {
      User? user = await _authService.register(email, password);
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
      User? user = await _authService.signIn(email, password);
      if (user != null) {
        emit(SuccessUserState(user: user));
      }
    } catch (e) {
      String msg = "";
      msg = e.toString().replaceAll("Exception", "Error");
      emit(FailureUserState(errorMessage: msg));
    }
  }
}
