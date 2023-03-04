part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

class DoLoginWithPassword extends LoginEvent {
  final String email;
  final String password;

  const DoLoginWithPassword({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class DoLogOut extends LoginEvent {
  const DoLogOut();

  @override
  List<Object> get props => [];
}

class DoLoginWithGoogle extends LoginEvent {
  const DoLoginWithGoogle();

  @override
  List<Object> get props => [];
}

class PhoneAuthStarted extends LoginEvent {
  final String phoneNumber;

  const PhoneAuthStarted(this.phoneNumber);
  @override
  List<Object> get props => [phoneNumber];
}

class PhoneAuthCompleted extends LoginEvent {
  final String smsCode;

  const PhoneAuthCompleted(this.smsCode);
  @override
  List<Object> get props => [smsCode];
}

class SignUp extends LoginEvent {
  final String email;
  final String password;

  const SignUp({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignInWithAnon extends LoginEvent {
  const SignInWithAnon();
}
