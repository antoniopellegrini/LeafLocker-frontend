import 'package:fe_app/blocs/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController passwordRepeatController = TextEditingController();
    TextEditingController firstnameController = TextEditingController();
    TextEditingController lastnameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
//        backgroundColor: Colors.transparent,

        centerTitle: true,
        title: Text(
          'Registra account',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.mail), hintText: 'Email', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0))),
              TextField(
                controller: passwordController,
                obscureText: true,
                autofocus: false,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.lock), hintText: 'Password', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)),
              ),
              TextField(
                controller: passwordRepeatController,
                obscureText: true,
                autofocus: false,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.lock), hintText: 'Conferma password', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text('Informazioni personali'),
              TextField(
                  controller: firstnameController,
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.person), hintText: 'Nome', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0))),
              TextField(
                  controller: lastnameController,
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.person), hintText: 'Cognome', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0))),
              TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  autofocus: false,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.phone), hintText: 'Cellulare', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0))),
              const SizedBox(height: 35.0),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthEventRegister(
                          email: emailController.text,
                          password: passwordController.text,
                          firstname: firstnameController.text,
                          lastname: lastnameController.text,
                          phone: phoneController.text));
                    },
                    child: const Text('Registra'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
