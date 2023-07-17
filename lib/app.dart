import 'package:fe_app/blocs/loading/loading.dart';
import 'package:fe_app/pages/cell/bloc/cubit/cell_cubit.dart';
import 'package:fe_app/pages/cell/cell.dart';
import 'package:fe_app/pages/cells/bloc/cubit/cells_cubit.dart';
import 'package:fe_app/pages/cells/cells.dart';
import 'package:fe_app/pages/home/bloc/home_cubit.dart';
import 'package:fe_app/pages/home/home.dart';
import 'package:fe_app/pages/lockers/lockers.dart';
import 'package:fe_app/pages/login/login.dart';
import 'package:fe_app/pages/register/register.dart';
import 'package:fe_app/pages/rent_cell/bloc/cubit/rent_cell_cubit.dart';
import 'package:fe_app/pages/rent_cell/rent_Cell.dart';
import 'package:fe_app/repository/auth_repository.dart';
import 'package:fe_app/repository/cell_repository.dart';
import 'package:fe_app/repository/locker_repository.dart';
import 'package:fe_app/repository/user_repository.dart';
import 'package:fe_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth/auth.dart';
import 'pages/lockers/bloc/lockers.dart';

class App extends StatelessWidget {
  const App({required this.authRepository, required this.lockerRepository, required this.userRepository, required this.cellRepository, super.key});

  final AuthRepository authRepository;
  final LockerRepository lockerRepository;
  final UserRepository userRepository;
  final CellRepository cellRepository;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoadingCubit()),
        BlocProvider(create: (context) => AuthBloc(authRepository: authRepository)..add(AuthEventOpenApp(loadingCubit: BlocProvider.of<LoadingCubit>(context)))),
        BlocProvider(create: (_) => LockersCubit(lockerRepository: lockerRepository)),
        BlocProvider(create: (_) => HomeCubit(userRepository: userRepository)),
        BlocProvider(create: (_) => CellsCubit(lockerRepository: lockerRepository)),
        BlocProvider(create: (_) => RentCellCubit(cellRepository: cellRepository)),
        BlocProvider(create: (_) => CellCubit(cellRepository: cellRepository)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: TAppTheme.lightTheme,
        darkTheme: ThemeData(brightness: Brightness.dark),
        themeMode: ThemeMode.light,
        title: 'LeafAPP',
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/homepage': (_) => const HomePage(),
          '/lockers': (_) => const LockersPage(),
          '/cells': (_) => const CellsPage(),
          '/rentCell': (_) => const RentCellPage(),
          '/cell': (_) => const CellPage(),
        },
      ),
    );
  }
}
