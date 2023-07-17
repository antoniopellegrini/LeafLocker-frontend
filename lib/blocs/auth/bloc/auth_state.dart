part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, registered, error }

class AuthState extends Equatable {
  const AuthState({this.status = AuthStatus.initial, this.email = '', this.password = '', this.accessToken = '', this.refreshToken = ''});
  final AuthStatus status;
  final String email;
  final String password;
  final String accessToken;
  final String refreshToken;

  AuthState copyWith({String? email, String? password, AuthStatus? status, String? accessToken, String? refreshToken}) {
    return AuthState(
        email: email ?? this.email,
        password: password ?? this.password,
        status: status ?? this.status,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken);
  }

  @override
  List<Object?> get props => [status, email, password, accessToken, refreshToken];
}
