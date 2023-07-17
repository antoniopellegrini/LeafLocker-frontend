import 'package:fe_app/blocs/auth/auth.dart';
import 'package:fe_app/blocs/loading/cubit/loading_cubit.dart';
import 'package:fe_app/pages/home/bloc/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previous, current) {
            if (previous.status == AuthStatus.authenticated && current.status == AuthStatus.authenticated) {
              return false;
            } else {
              return true;
            }
          },
          listener: (context, state) {
            final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
            homeCubit.loadInitialState();
            if (state.status == AuthStatus.authenticated) {
              Navigator.pushNamed(context, "/homepage");
            }
          },
        ),
        BlocListener<LoadingCubit, LoadingState>(
          listener: (context, state) {
            if (state.status == LoadingStatus.loading) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const Center(child: CircularProgressIndicator());
                  });
            }
            if (state.status == LoadingStatus.notLoading) {
              Navigator.of(context).pop();
            }
            if (state.status == LoadingStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red[500],
                content: Text("${state.error}: ${state.message}"),
              ));
            }
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo_leaf_green.png',
                    height: 100,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Leaf Locker',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofocus: false,
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.person), hintText: 'Email', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0))),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    autofocus: false,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.lock), hintText: 'Password', contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0)),
                  ),
                  const SizedBox(height: 50.0),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(AuthEventRequestLogin(email: emailController.text, password: passwordController.text));
                          },
                          child: const Text('Login'),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ]),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("Non hai un account? clicca qui per registrarlo"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
