part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

// with password
class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMessage;
  const LoginFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

// log out
class LogOutLoading extends LoginState {}

class LogOutSuccess extends LoginState {}

class LogOutFailure extends LoginState {
  final String errorMessage;
  const LogOutFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
// with Google

class LoginGoogleLoading extends LoginState {}

class LoginGoogleSuccess extends LoginState {}

class LoginGoogleFailure extends LoginState {
  final String errorMessage;
  const LoginGoogleFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

// with phone
class LoginPhoneLoading extends LoginState {}

class LoginPhoneSuccess extends LoginState {}

class LoginPhoneComplete extends LoginState {
  final UserEntity user;
  const LoginPhoneComplete(this.user);
  @override
  List<Object> get props => [user];
}

class LoginPhoneFailure extends LoginState {
  final String errorMessage;
  const LoginPhoneFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

// sign up
class SignUpLoading extends LoginState {}

class SignUpSuccess extends LoginState {
  final UserEntity user;
  const SignUpSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class SignUpFailure extends LoginState {
  final String errorMessage;
  const SignUpFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class SignInWithAnonLoading extends LoginState {}

class SignInWithAnonSuccess extends LoginState {}

class SignInWithAnonFailure extends LoginState {
  final String errorMessage;
  const SignInWithAnonFailure(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
