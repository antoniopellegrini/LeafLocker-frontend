import 'package:fe_app/pages/cells/bloc/cubit/cells_cubit.dart';
import 'package:fe_app/pages/rent_cell/bloc/rent_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CellsPage extends StatelessWidget {
  const CellsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CellsCubit cellsCubit = BlocProvider.of<CellsCubit>(context);
    //cellsCubit.loadFreeLockerCells(cellsCubit.state.lockerId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Celle disponibili',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<CellsCubit, CellsState>(
            builder: (context, state) {
              if (state.status == CellsStatus.loaded) {
                return TextButton(
                  onPressed: () {
                    cellsCubit.loadFreeLockerCells(state.lockerId);
                  },
                  child: const Icon(Icons.refresh, color: Colors.white),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "Seleziona una cella:",
            textScaleFactor: 1.3,
            style: TextStyle(fontWeight: FontWeight.w400),
            textAlign: TextAlign.start,
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<CellsCubit, CellsState>(
                builder: (context, state) {
                  if (state.status == CellsStatus.loaded) {
                    List<String> smallCells = [];
                    List<String> largeCells = [];

                    for (var cell in state.cellsList) {
                      if (cell['dimension'] == 'small') {
                        smallCells.add(cell['id']);
                      } else {
                        largeCells.add(cell['id']);
                      }
                    }

                    Widget smallCell = InkWell(
                      onTap: () async {
                        final RentCellCubit rentCellCubit = BlocProvider.of<RentCellCubit>(context);

                        rentCellCubit.loadInitialState();
                        rentCellCubit.loadCellPlants(smallCells[0]);
                        await Navigator.pushNamed(context, '/rentCell');
                      },
                      child: Container(
                        width: 200,
                        height: 120,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                            borderRadius: const BorderRadius.all(Radius.circular(15))),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (smallCells.isEmpty)
                              Column(
                                children: [
                                  const Text(
                                    "Cella piccola",
                                    textScaleFactor: 1.4,
                                    style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${smallCells.length} rimanenti",
                                    textScaleFactor: 1.2,
                                    style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
                                    textAlign: TextAlign.right,
                                  )
                                ],
                              )
                            else
                              Column(
                                children: [
                                  const Text(
                                    "Cella piccola",
                                    textScaleFactor: 1.4,
                                    style: TextStyle(fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${smallCells.length} rimanenti",
                                    textScaleFactor: 1.2,
                                    style: const TextStyle(fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.right,
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
                    );

                    Widget largeCell = InkWell(
                      onTap: largeCells.isEmpty
                          ? null
                          : () async {
                              final RentCellCubit rentCellCubit = BlocProvider.of<RentCellCubit>(context);

                              rentCellCubit.loadInitialState();
                              rentCellCubit.loadCellPlants(largeCells[0]);
                              await Navigator.pushNamed(context, '/rentCell');
                            },
                      child: Container(
                        width: 230,
                        height: 150,
                        decoration: BoxDecoration(
                            color: largeCells.isEmpty ? Colors.grey[200] : Colors.white,
                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                            borderRadius: const BorderRadius.all(Radius.circular(15))),
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (largeCells.isEmpty)
                              Column(
                                children: [
                                  const Text(
                                    "Cella grande",
                                    textScaleFactor: 1.4,
                                    style: TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${largeCells.length} rimanenti",
                                    textScaleFactor: 1.2,
                                    style: const TextStyle(fontWeight: FontWeight.w400, color: Colors.grey),
                                    textAlign: TextAlign.right,
                                  )
                                ],
                              )
                            else
                              Column(
                                children: [
                                  const Text(
                                    "Cella grande",
                                    textScaleFactor: 1.4,
                                    style: TextStyle(fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${largeCells.length} rimanenti",
                                    textScaleFactor: 1.2,
                                    style: const TextStyle(fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.right,
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
                    );

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        smallCell,
                        const SizedBox(
                          height: 40,
                        ),
                        largeCell
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}


  // for (var cell in state.cellsList) {
                //   cells.add(InkWell(
                //     onTap: () async {
                //       final RentCellCubit rentCellCubit = BlocProvider.of<RentCellCubit>(context);

                //       rentCellCubit.loadInitialState();
                //       rentCellCubit.loadCellPlants(cell['id']);
                //       await Navigator.pushNamed(context, '/rentCell');
                //     },
                //     child: (Container(
                //       width: double.infinity,
                //       decoration: BoxDecoration(
                //           color: Colors.white,
                //           boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 4, offset: const Offset(0, 2))],
                //           borderRadius: const BorderRadius.all(Radius.circular(15))),
                //       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                //       margin: const EdgeInsets.only(top: 10),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             "Cell ID: ${cell['numeric_id']}",
                //             textScaleFactor: 1.2,
                //             style: const TextStyle(fontWeight: FontWeight.w400),
                //             textAlign: TextAlign.left,
                //           ),
                //           Text(
                //             "Dimension: ${cell['dimension']}",
                //             textScaleFactor: 1.2,
                //             style: const TextStyle(fontWeight: FontWeight.w400),
                //             textAlign: TextAlign.right,
                //           )
                //         ],
                //       ),
                //     )),
                //   ));
                // }