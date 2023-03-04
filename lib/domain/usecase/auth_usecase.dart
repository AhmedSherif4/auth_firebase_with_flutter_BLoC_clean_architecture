// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:firebase_auth_flutter/core/failure/failure.dart';

import '../entity/user.dart';
import '../repository/base_auth_repository.dart';

abstract class FirebaseAuthUseCaseBase {
  BaseAuthRepository baseAuthRepository;
  FirebaseAuthUseCaseBase(
    this.baseAuthRepository,
  );
}

class SignInUseCase extends FirebaseAuthUseCaseBase {
  SignInUseCase(super.baseAuthRepository);

  Future<Either<Failure, UserEntity>> call(
      String email, String password) async {
    return await baseAuthRepository.signInWithPassword(email, password);
  }
}

class SignOutUseCase extends FirebaseAuthUseCaseBase {
  SignOutUseCase(super.authenticationService);

  Future<Either<Failure, Unit>> call() async {
    return await baseAuthRepository.signOut();
  }
}

class SignInWithGoogleUseCase extends FirebaseAuthUseCaseBase {
  SignInWithGoogleUseCase(super.authenticationService);

  Future<Either<Failure, UserEntity>> call() async {
    return await baseAuthRepository.signInWithGoogle();
  }
}

class SignInWithPhoneUseCase extends FirebaseAuthUseCaseBase {
  SignInWithPhoneUseCase(super.authenticationService);

  //? phone functions
  Future<Either<Failure, UserEntity>> signInWithOTP(String smsCode) async {
    return await baseAuthRepository.signInWithOTP(smsCode);
  }

  Future<Either<Failure, Unit>> verifyPhone(String phoneNo) async {
    return await baseAuthRepository.verifyPhone(phoneNo);
  }
}

class SignUpUseCase extends FirebaseAuthUseCaseBase {
  SignUpUseCase(super.baseAuthRepository);

  Future<Either<Failure, UserEntity>> call(
      {required String email, required String password}) async {
    return await baseAuthRepository.signUp(email: email, password: password);
  }
}

class SignInWithAnonUseCase extends FirebaseAuthUseCaseBase {
  SignInWithAnonUseCase(super.baseAuthRepository);

  Future<Either<Failure, Unit>> call() async {
    return await baseAuthRepository.signInAnonymously();
  }
}
