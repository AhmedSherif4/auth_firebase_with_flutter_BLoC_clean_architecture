import 'package:firebase_auth_flutter/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/dependency_injection.dart';
import '../controller/login/login_bloc.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/snack_bar.dart';

class OtpVerificationBody extends StatelessWidget {
  OtpVerificationBody({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _smsCode = TextEditingController();

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
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          height: size.height * 0.45,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10.0,
                spreadRadius: 0.0,
                offset: const Offset(2.0, 5.0),
              ),
            ],
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 10.0,
            margin: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 40.0),
                  padding: const EdgeInsets.all(20.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: "Verification\n\n",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0278AE),
                          ),
                        ),
                        TextSpan(
                          text: "Enter the OTP send to your mobile number",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF373A40),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  child: _form(),
                ),
              ],
            ),
          ),
        ),
        BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginPhoneLoading) {
              showDialog(
                context: context,
                builder: (BuildContext ctx) => alert,
                barrierDismissible: true,
              );
            } else if (state is LoginPhoneComplete) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (BuildContext context) =>  Home(user: state.user),
                ),
                (route) => false,
              );
            } else if (state is LoginPhoneFailure) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBarWidget(state.errorMessage));
            }
          },
          builder: (context, state) => ElevatedButton(
            onPressed: () {
              BlocProvider.of<LoginBloc>(context).add(
                PhoneAuthCompleted(_smsCode.text),
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            child: const Text('Verify Mobile Phone'),
          ),
        ),
      ],
    );
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _smsCode,
            decoration: InputDecoration(
              labelText: 'Verify Your Phone Number',
              suffixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
