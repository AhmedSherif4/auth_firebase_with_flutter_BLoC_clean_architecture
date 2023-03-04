import 'package:firebase_auth_flutter/core/dependency_injection.dart';
import 'package:firebase_auth_flutter/ui/controller/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/user.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/snack_bar.dart';
import 'pages.dart';

class Home extends StatelessWidget {
  UserEntity? user;
  Home({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getItObject<LoginBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HOME'),
        ),
        body: _body(),
      ),
    );
  }

  Center _body() {
    return Center(
      child: Column(
        children: [
          Text(user?.name ?? ' name of user'),
          Text(user?.email ?? ' email of user'),
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LogOutSuccess) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  ),
                  (route) => false,
                );
              } else if (state is LogOutFailure) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(snackBarWidget(state.errorMessage));
              } else if (state is LogOutLoading) {
                showDialog(
                  context: context,
                  builder: (BuildContext ctx) => alert,
                  barrierDismissible: true,
                );
              }
            },
            builder: (context, state) => TextButton(
              onPressed: () =>
                  BlocProvider.of<LoginBloc>(context).add(const DoLogOut()),
              child: const Text('LogOut'),
            ),
          ),
        ],
      ),
    );
  }
}
