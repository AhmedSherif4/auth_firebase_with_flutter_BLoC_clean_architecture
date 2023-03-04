// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_flutter/core/exception/exception.dart';

import 'package:firebase_auth_flutter/core/failure/failure.dart';
import 'package:firebase_auth_flutter/domain/entity/user.dart';
import 'package:firebase_auth_flutter/domain/repository/base_auth_repository.dart';

import '../data_source/auth_with_firebase.dart';

class AuthRepository extends BaseAuthRepository {
  BaseAuthenticationService authenticationService;
  AuthRepository(
    this.authenticationService,
  );

  @override
  Future<Either<Failure, UserEntity>> signInWithPassword(
      String email, String password) async {
    final result =
        await authenticationService.signInWithPassword(email, password);
    try {
      return Right(result);
    } on FirebaseAuthException catch (error) {
      return Left(LogInWithEmailAndPasswordFailure(error.code));
    } catch (error) {
      return Left(LogInWithEmailAndPasswordFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await authenticationService.signOut();
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(LogOutFailure(e.code));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    final result = await authenticationService.signInWithGoogle();
    try {
      return Right(result);
    } on FirebaseAuthException catch (error) {
      return Left(LogInWithGoogleFailure(error.code));
    } catch (error) {
      return Left(LogInWithGoogleFailure(error.toString()));
    }
  }

  //? phone methods
  @override
  Future<Either<Failure, UserEntity>> signInWithOTP(String smsCode) async {
    final result = await authenticationService.signInWithOTP(smsCode);
    try {
      return Right(result);
    } on FirebaseAuthException catch (error) {
      return Left(LogInWithOTP(error.code));
    } catch (error) {
      return Left(LogInWithOTP(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyPhone(String phoneNo) async {
    try {
      await authenticationService.verifyPhone(phoneNo);
      return const Right(unit);
    } on FirebaseAuthException catch (error) {
      return Left(LogInWithOTP(error.code));
    } catch (error) {
      return Left(LogInWithOTP(error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signInAnonymously() async {
    try {
      await authenticationService.signInAnonymously();
      return const Right(unit);
    } on FirebaseAuthException catch (e) {
      return Left(LogInWithAnon.fromCode(e.code));
    } catch (_) {
      return const Left(LogInWithAnon());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      {required String email, required String password}) async {
    try {
      final result =
          await authenticationService.signUp(email: email, password: password);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(SignUpWithEmailAndPasswordFailure.fromCode(e.code));
    } catch (_) {
      return const Left(SignUpWithEmailAndPasswordFailure());
    }
  }
}
