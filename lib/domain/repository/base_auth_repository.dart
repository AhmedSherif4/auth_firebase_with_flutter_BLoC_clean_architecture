import 'package:dartz/dartz.dart';
import 'package:firebase_auth_flutter/domain/entity/user.dart';

import '../../core/failure/failure.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, UserEntity>> signInWithPassword(
      String email, String password);
  Future<Either<Failure, Unit>> signOut();
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  //? phone functions
  Future<Either<Failure, UserEntity>> signInWithOTP(String smsCode);
  Future<Either<Failure, Unit>> verifyPhone(String phoneNo);
  Future<Either<Failure, Unit>> signInAnonymously();
  Future<Either<Failure, UserEntity>> signUp({required String email, required String password});


}
