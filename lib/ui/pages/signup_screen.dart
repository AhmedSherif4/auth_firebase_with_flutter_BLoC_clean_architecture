import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/dependency_injection.dart';
import '../controller/login/login_bloc.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/snack_bar.dart';
import 'home.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getItObject<LoginBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login page'),
        ),
        body: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is SignUpLoading) {
            showDialog(
              context: context,
              builder: (BuildContext ctx) => alert,
              barrierDismissible: true,
            );
          } else if (state is SignUpSuccess) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(user: state.user),
              ),
            );
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(snackBarWidget(state.errorMessage));
          } else if (state is LoginGoogleLoading) {
            showDialog(
              context: context,
              builder: (BuildContext ctx) => alert,
              barrierDismissible: true,
            );
          }
        },
        builder: (context, state) => _build(context),
      ),
    );
  }

  Column _build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        form(),
        ElevatedButton(
          onPressed: () {
            BlocProvider.of<LoginBloc>(context)
                .add(SignUp(email: _email.text, password: _password.text));
          },
          child: const Text('Sign Up'),
        ),
      ],
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _email,
            decoration: InputDecoration(
              labelText: 'Email',
              suffixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: _validatorEmail,
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            validator: _validatorPassword,
            controller: _password,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              suffixIcon: const Icon(Icons.donut_small),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? _validatorEmail(String? value) {
    if (value == null || value.isEmpty /* condition rgex email */) {
      return 'please enter your email';
    } else {
      return null;
    }
  }

  String? _validatorPassword(String? value) {
    if (value == null || value.length < 8 /* condition rgex password */) {
      return 'please enter your password';
    } else {
      return null;
    }
  }
}
