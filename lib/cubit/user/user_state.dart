part of 'user_cubit.dart';

abstract class UserState extends Equatable {}

class InitialUserState extends UserState {
  @override
  List<Object?> get props => [];
}

class LoadingRegisterUserState extends UserState {
  @override
  List<Object?> get props => [];
}

class LoadingLoginUserState extends UserState {
  @override
  List<Object?> get props => [];
}

class FailureUserState extends UserState {
  final String errorMessage;

  FailureUserState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class SuccessUserState extends UserState {
  final User user;
  SuccessUserState({required this.user});

  @override
  List<Object?> get props => [user];
}
