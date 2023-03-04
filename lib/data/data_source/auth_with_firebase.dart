import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth_flutter/data/models/user_model.dart';

import '../../core/failure/failure.dart';

abstract class BaseAuthenticationService {
  Future<UserModel> signInWithPassword(String email, String password);
  Future signOut();
  Future<UserModel> signInWithGoogle();
  //? phone functions
  Future<UserModel> signInWithOTP(String smsCode);
  Future<void> verifyPhone(String phoneNo);
  Future<void> signInAnonymously();
  Future<UserModel> signUp({required String email, required String password});
}

class FirebaseAuthentication implements BaseAuthenticationService {
  FirebaseAuth authFirebaseInstance = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<UserModel> signInWithPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return UserModel(
        email: email,
        name: userCredential.user?.displayName ?? 'username',
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      Future.wait([
        authFirebaseInstance.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw LogOutFailure(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      late final AuthCredential credential;
      if (kIsWeb) {
        final googleProvider = GoogleAuthProvider();
        final userCredential = await authFirebaseInstance.signInWithPopup(
          googleProvider,
        );
        credential = userCredential.credential!;
      } else {
        // Trigger the authentication flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
      }

      final userCredential = await mSignInCredential(credential);
      // Once signed in, return the UserCredential
      return UserModel(
        email: userCredential.user?.email ?? 'email',
        name: userCredential.user?.displayName ?? 'username',
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithGoogleFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithGoogleFailure();
    }
  }

// sign in with phone number
  static String verId = '';
  Future<UserCredential> mSignInCredential(AuthCredential authCreds) async {
    return await authFirebaseInstance.signInWithCredential(authCreds);
  }

  @override
  Future<UserModel> signInWithOTP(String smsCode) async {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    final userCredential = await mSignInCredential(authCreds);
    try {
      return UserModel(
        email: userCredential.user?.phoneNumber ?? 'email',
        name: userCredential.user?.displayName ?? 'username',
      );
    } on FirebaseAuthException catch (e) {
      throw LogInWithOTP.fromCode(e.code);
    } catch (_) {
      throw const LogInWithOTP();
    }
  }

  @override
  Future<void> verifyPhone(String phoneNo) async {
    verified(AuthCredential authResult) async {
      // await mSignInCredential(authResult);
      
    }

    verificationFailed(FirebaseAuthException authException) {
      

      if (authException.code == 'invalid-phone-number') {
        throw LogInWithOTP(authException.code);
      } else {
        throw LogInWithOTP(authException.code);
      }
    }

    smsSent(String verificationId, int? forceResend) {
      verId = verificationId;
      
    }

    autoTimeout(String verificationId) {
      verId = verificationId;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+2$phoneNo',
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
    
  }

  @override
  Future<void> signInAnonymously() async {
    try {
      // make variable for link with real email in the future.
      // ignore: unused_local_variable
      final UserCredential userCredential =
          await authFirebaseInstance.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw LogInWithAnon.fromCode(e.code);
    } catch (_) {
      throw const LogInWithAnon();
    }
  }

  @override
  Future<UserModel> signUp(
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential =
          await authFirebaseInstance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel(
        email: userCredential.user?.email ?? 'email',
        name: userCredential.user?.displayName ?? 'username',
      );
    } on FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }
}
