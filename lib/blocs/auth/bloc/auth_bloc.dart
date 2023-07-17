import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_app/blocs/loading/cubit/loading_cubit.dart';
import 'package:fe_app/repository/auth_repository.dart';
import 'package:fe_app/shared/http.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(const AuthState()) {
    on<AuthEventOpenApp>(_onAppOpened);
    on<AuthEventRequestLogin>(_onLoginRequested);
    on<AuthEventLogout>(_onLogoutRequested);
    on<AuthEventRegister>(_onRegisterRequested);
    on<AuthEventRefreshToken>(_onRefreshToken);
  }

  final AuthRepository _authRepository;

  Future<void> _onAppOpened(AuthEventOpenApp event, Emitter<AuthState> emit) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    attachInterceptor(dioInstance, event.loadingCubit, this, _authRepository);

    String? accessToken = preferences.getString('access_token');
    String? refreshToken = preferences.getString('refresh_token');

    if (accessToken != null && refreshToken != null) {
      updateAuthorizationHeaders(dioInstance, accessToken);
      emit(state.copyWith(status: AuthStatus.authenticated, accessToken: accessToken, refreshToken: refreshToken));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onLoginRequested(AuthEventRequestLogin event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    var res = await _authRepository.login(event.email, event.password);
    if (res?.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      preferences.setString("access_token", res.data['access_token']);
      preferences.setString("refresh_token", res.data['refresh_token']);

      updateAuthorizationHeaders(dioInstance, res.data['access_token']);

      emit(state.copyWith(status: AuthStatus.authenticated, accessToken: res.data['access_token'], refreshToken: res.data['refresh_token']));
    } else {
      if (kDebugMode) {
        print("Unauthenticated!");
      }
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> _onRegisterRequested(AuthEventRegister event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    var res = await _authRepository.register(event.email, event.password, event.firstname, event.lastname, event.phone);
    if (res.statusCode == 200) {
      emit(const AuthState(status: AuthStatus.registered));
    } else {
      if (kDebugMode) {
        print("Unauthenticated!");
      }
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> _onRefreshToken(AuthEventRefreshToken event, Emitter<AuthState> emit) async {
    emit(state.copyWith(accessToken: event.newAccessToken));
  }

  Future<void> _onLogoutRequested(AuthEventLogout event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    var res = await _authRepository.logout();

    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.clear();

    updateAuthorizationHeaders(dioInstance, '');

    emit(state.copyWith(status: AuthStatus.unauthenticated));
  }
}
