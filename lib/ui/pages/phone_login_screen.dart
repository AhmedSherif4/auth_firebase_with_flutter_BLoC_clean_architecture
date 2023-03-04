import 'package:firebase_auth_flutter/ui/controller/login/login_bloc.dart';
import 'package:firebase_auth_flutter/ui/pages/verify_phone_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/dependency_injection.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/snack_bar.dart';
import 'home.dart';

class PhoneLoginScreen extends StatelessWidget {
  PhoneLoginScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getItObject<LoginBloc>(),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            
          ),
          Form(
            key: _formKey,
            child: TextFormField(

              keyboardType: TextInputType.phone,
              controller: _phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                suffixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              validator: _validatorPhone,
            ),
          ),
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context)
                      .add(PhoneAuthStarted(_phone.text));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => OtpVerificationBody(),
                  ));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: const Text('Send code'),
              );
            },
          ),
        ],
      ),
    );
  }

  String? _validatorPhone(String? value) {
    if (value == null || value.isEmpty /**condition rgex phone */) {
      return 'please put your phone number';
    } else {
      return null;
    }
  }
}
