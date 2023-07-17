import 'package:fe_app/repository/auth_repository.dart';
import 'package:fe_app/repository/cell_repository.dart';
import 'package:fe_app/repository/locker_repository.dart';
import 'package:fe_app/repository/user_repository.dart';
import 'package:fe_app/shared/http.dart';
import 'package:flutter/widgets.dart';
import 'package:fe_app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:fe_app/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Bloc.observer = const SimpleBlocObserver();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? accessToken = preferences.getString('access_token');
  if (accessToken != null) {
    updateAuthorizationHeaders(dioInstance, accessToken);
  }

  runApp(App(
    authRepository: AuthRepository(),
    lockerRepository: LockerRepository(),
    userRepository: UserRepository(),
    cellRepository: CellRepository(),
  ));
}
