part of 'auth_bloc.dart';

class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthEventRequestLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthEventRequestLogin({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthEventRefreshToken extends AuthEvent {
  final String newAccessToken;
  const AuthEventRefreshToken({required this.newAccessToken});
}

class AuthEventOpenApp extends AuthEvent {
  final LoadingCubit loadingCubit;

  const AuthEventOpenApp({required this.loadingCubit});
  @override
  List<Object?> get props => [loadingCubit];
}

class AuthEventLogout extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String firstname;
  final String lastname;
  final String phone;

  const AuthEventRegister({required this.email, required this.password, required this.firstname, required this.lastname, required this.phone});

  @override
  List<Object?> get props => [email, password, firstname, lastname, phone];
}
