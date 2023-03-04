import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth_flutter/core/failure/failure.dart';
import 'package:firebase_auth_flutter/domain/entity/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecase/auth_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  SignInUseCase signInUseCase;
  SignOutUseCase signOutUseCase;
  SignInWithGoogleUseCase signInWithGoogleUseCase;
  SignInWithPhoneUseCase signInWithPhoneUseCase;
  SignUpUseCase signUpUseCase;
  SignInWithAnonUseCase signInWithAnonUseCase;

  LoginBloc(
      this.signInUseCase,
      this.signOutUseCase,
      this.signInWithGoogleUseCase,
      this.signInWithPhoneUseCase,
      this.signUpUseCase,
      this.signInWithAnonUseCase)
      : super(LoginInitial()) {
    on<DoLoginWithPassword>(_onDoLoginWithPassword);
    on<DoLogOut>(_onDoLogOut);
    on<DoLoginWithGoogle>(_onDoLoginWithGoogle);
    on<PhoneAuthStarted>(_onPhoneAuthStarted);
    on<PhoneAuthCompleted>(_onPhoneAuthCompleted);
    on<SignUp>(_onSignUp);
    on<SignInWithAnon>(_onSignInWithAnon);
  }

  Future _onDoLoginWithPassword(
      DoLoginWithPassword event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    final Either<Failure, UserEntity> result =
        await signInUseCase(event.email, event.password);
    result.fold((failure) => emit(LoginFailure(failure.message)),
        (user) => emit(LoginSuccess()));
  }

  Future _onDoLogOut(DoLogOut event, Emitter<LoginState> emit) async {
    emit(LogOutLoading());
    final result = await signOutUseCase();
    result.fold(
      (failure) => emit(
        LogOutFailure(failure.toString()),
      ),
      (_) => emit(LogOutSuccess()),
    );
  }

  Future _onDoLoginWithGoogle(
      DoLoginWithGoogle event, Emitter<LoginState> emit) async {
    emit(LoginGoogleLoading());
    final Either<Failure, UserEntity> result = await signInWithGoogleUseCase();
    result.fold((failure) => emit(LoginGoogleFailure(failure.message)),
        (user) => emit(LoginGoogleSuccess()));
  }

  //? phone functions

  Future _onPhoneAuthStarted(
      PhoneAuthStarted event, Emitter<LoginState> emit) async {
    emit(LoginPhoneLoading());
    final result = await signInWithPhoneUseCase.verifyPhone(event.phoneNumber);
    result.fold(
      (failure) => emit(LoginPhoneFailure(failure.message)),
      (_) => emit(LoginPhoneSuccess()),
    );
    /* emit(LoginPhoneLoading());
    final mAuth = FirebaseAuth.instance;
    // await mAuth.setSettings(appVerificationDisabledForTesting: false, forceRecaptchaFlow: true);

    try {
      await mAuth.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (phoneAuthCredential) {
          /* final result = await signInWithPhoneUseCase
            .verificationCompleted(phoneAuthCredential);
        result.fold(
          (failure) => emit(LoginGoogleFailure(failure.message)),
          (userCredential) => null,
        ); */
        },
        verificationFailed: (error) {
          /*         final Failure failure =
            signInWithPhoneUseCase.verificationFailed(error); */
          emit(LoginPhoneFailure(error.message!));
        },
        codeSent: (verificationId, forceResendingToken) {
          add(PhoneAuthCompleted(verificationId: verificationId, smsCode: ''));
        },
        timeout: const Duration(seconds: 120),
        codeAutoRetrievalTimeout: (verificationId) {
/*         final Failure failure =
            signInWithPhoneUseCase.codeAutoRetrievalTimeout(verificationId);
        emit(LoginPhoneFailure(failure.message)); */
        },
      );
    } catch (e) {
      emit(LoginPhoneFailure(e.toString()));
    } */
  }

  Future _onPhoneAuthCompleted(
      PhoneAuthCompleted event, Emitter<LoginState> emit) async {
    // emit(LoginPhoneLoading());
    final result = await signInWithPhoneUseCase.signInWithOTP(event.smsCode);
    result.fold(
      (failure) => emit(LoginPhoneFailure(failure.message)),
      (user) => emit(LoginPhoneComplete(user)),
    );
    /*  emit(LoginPhoneLoading());
    final mAuth = FirebaseAuth.instance;
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
      );
      await mAuth.signInWithCredential(credential);
      emit(const LoginPhoneSuccess());
/*       final result = await signInWithPhoneUseCase.codeSent(
          verificationId, forceResendingToken, smsCode);
      result.fold(
        (failure) => emit(LoginGoogleFailure(failure.message)),
        (user) => emit(const LoginPhoneSuccess()),
      ); */
    } catch (e) {
      emit(LoginPhoneFailure(e.toString()));
    } */
  }

  Future _onSignUp(SignUp event, Emitter<LoginState> emit) async {
    emit(SignUpLoading());
    final Either<Failure, UserEntity> result =
        await signUpUseCase(email: event.email, password: event.password);
    result.fold((failure) => emit(SignUpFailure(failure.message)),
        (user) => emit(SignUpSuccess(user)));
  }

  Future _onSignInWithAnon(
      SignInWithAnon event, Emitter<LoginState> emit) async {
    emit(SignInWithAnonLoading());
    final result = await signInWithAnonUseCase();
    result.fold(
      (failure) => emit(SignInWithAnonFailure(failure.message)),
      (_) => emit(SignInWithAnonSuccess()),
    );
  }
}
