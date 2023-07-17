import 'package:fe_app/blocs/auth/auth.dart';
import 'package:fe_app/pages/cell/bloc/cell.dart';
import 'package:fe_app/pages/home/bloc/home_cubit.dart';
import 'package:fe_app/pages/lockers/bloc/lockers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeCubit userCubit = BlocProvider.of<HomeCubit>(context);
    userCubit.loadRentedLockerCells();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () {
            final LockersCubit lockersCubit = BlocProvider.of<LockersCubit>(context);
            lockersCubit.loadInitialState();
            lockersCubit.loadLockerList();
            Navigator.pushNamed(context, '/lockers');
          }),
      appBar: AppBar(
        title: Text(
          'Le mie celle',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        leading: TextButton(
            onPressed: () {
              final AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);

              authBloc.add(AuthEventLogout());
            },
            child: const Icon(
              Icons.logout,
              color: Colors.white,
            )),
        actions: [
          MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.status == AuthStatus.unauthenticated) {
                    Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false);
                  }
                },
              ),
            ],
            child: TextButton(
              onPressed: () {
                userCubit.loadRentedLockerCells();
              },
              child: const Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.status == HomeStatus.listLoaded) {
                    List<Widget> lockersWithRentedCells = [];

                    for (var locker in state.rentedLockerCells) {
                      List<Widget> lockerCells = [];

                      print(locker['cells']);

                      for (var cell in locker['cells']) {
                        lockerCells.add(InkWell(
                          onTap: () async {
                            final CellCubit cellCubit = BlocProvider.of<CellCubit>(context);

                            cellCubit.loadInitialState(cell['id'], cell['numeric_id'], locker['location']);
                            cellCubit.loadCellInfo();

                            await Navigator.pushNamed(context, '/cell');
                          },
                          child: (Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                                borderRadius: const BorderRadius.all(Radius.circular(15))),
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                cell['status'] == 'in_use'
                                    ? Image.asset(
                                        'assets/images/microgreen.png',
                                        height: 60,
                                        width: 60,
                                      )
                                    : Image.asset(
                                        'assets/images/vaso.png',
                                        height: 50,
                                        width: 65,
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Cella: ${cell['numeric_id']}",
                                      textScaleFactor: 1.2,
                                      style: const TextStyle(fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.left,
                                    ),

                                    const SizedBox(
                                      height: 6,
                                    ),
                                    // Text(
                                    //   "Dimensione: ${cell['dimension'] == 'small' ? 'piccola' : 'grande'}",
                                    //   textScaleFactor: 1.2,
                                    //   style: const TextStyle(fontWeight: FontWeight.w400),
                                    //   textAlign: TextAlign.right,
                                    // ),
                                    Text(
                                      cell['status'] == 'in_use' ? 'coltivazione in corso' : 'la cella è vuota',
                                      textScaleFactor: 1.2,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.right,
                                    ),
                                    if (cell['status'] == 'in_use')
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Pianta: ${cell['seed']['name']}",
                                            textScaleFactor: 1.2,
                                            style: const TextStyle(fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.right,
                                          ),
                                          Text(
                                            "Giorno di crescita: ${((DateTime.now().millisecondsSinceEpoch - double.parse(cell['rent'][0]['start'])) / 84000000).ceil() - 1}/${cell['seed']['esimated_growth_time']}",
                                            textScaleFactor: 1.2,
                                            style: const TextStyle(fontWeight: FontWeight.w400),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ],
                            ),
                          )),
                        ));
                      }

                      lockersWithRentedCells.add(Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Locker: ${locker['location']}",
                              textScaleFactor: 1.2,
                              style: const TextStyle(fontWeight: FontWeight.w400),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Column(
                            children: [...lockerCells],
                          ),
                          Builder(builder: (context) {
                            return const SizedBox(
                              height: 20,
                            );
                          })
                        ],
                      ));
                    }
                    if (lockersWithRentedCells.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nessuna cella affittata',
                          textScaleFactor: 1.4,
                        ),
                      );
                    } else {
                      return Column(
                        children: [...lockersWithRentedCells],
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
