import 'package:fe_app/pages/cells/bloc/cubit/cells_cubit.dart';
import 'package:fe_app/pages/lockers/bloc/lockers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LockersPage extends StatelessWidget {
  const LockersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LockersCubit lockersCubit = BlocProvider.of<LockersCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Locker disponibili',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              lockersCubit.loadLockerList();
            },
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<LockersCubit, LockersState>(
                builder: (context, state) {
                  if (state.status == LockersStatus.loaded) {
                    List<Widget> lockers = [];

                    for (var locker in state.lockerList) {
                      lockers.add(InkWell(
                        onTap: () async {
                          final CellsCubit cellsCubit = BlocProvider.of<CellsCubit>(context);

                          cellsCubit.loadInitialState();
                          cellsCubit.loadFreeLockerCells(locker['locker']['id']);
                          await Navigator.pushNamed(context, '/cells');
                        },
                        child: (Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                              borderRadius: const BorderRadius.all(Radius.circular(15))),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Locker: ${locker['locker']['location']}",
                                textScaleFactor: 1.2,
                                style: const TextStyle(fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                "${locker['n_free_cells']} celle disponibili",
                                textScaleFactor: 1.2,
                                style: const TextStyle(fontWeight: FontWeight.w400),
                                textAlign: TextAlign.right,
                              )
                            ],
                          ),
                        )),
                      ));
                    }
                    return Column(
                      children: lockers.isEmpty
                          ? [
                              const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Nessun locker disponibile',
                                  textScaleFactor: 1.4,
                                ),
                              )
                            ]
                          : [...lockers],
                    );
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
