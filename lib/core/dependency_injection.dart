import 'package:firebase_auth_flutter/data/repository/auth_repository.dart';
import 'package:firebase_auth_flutter/domain/repository/base_auth_repository.dart';

import '../data/data_source/auth_with_firebase.dart';
import '../domain/usecase/auth_usecase.dart';
import '../ui/controller/login/login_bloc.dart';
import 'package:get_it/get_it.dart';

final getItObject = GetIt.instance;

class ServerLocator {
  static void setup() {
    // Blocs
    getItObject.registerFactory(() => LoginBloc(getItObject(), getItObject(),
        getItObject(), getItObject(), getItObject(), getItObject()));

    // Use cases
    getItObject.registerLazySingleton(() => SignInUseCase(getItObject()));
    getItObject.registerLazySingleton(() => SignOutUseCase(getItObject()));
    getItObject
        .registerLazySingleton(() => SignInWithGoogleUseCase(getItObject()));
    getItObject
        .registerLazySingleton(() => SignInWithPhoneUseCase(getItObject()));
    getItObject.registerLazySingleton(() => SignUpUseCase(getItObject()));
    getItObject
        .registerLazySingleton(() => SignInWithAnonUseCase(getItObject()));

    // repository
    getItObject.registerLazySingleton<BaseAuthRepository>(
      () => AuthRepository(getItObject()),
    );

    // Infra services
    getItObject.registerLazySingleton<BaseAuthenticationService>(
        () => FirebaseAuthentication());
  }
}
