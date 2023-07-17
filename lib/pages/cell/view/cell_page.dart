import 'package:fe_app/pages/cell/bloc/cell.dart';
import 'package:fe_app/pages/home/bloc/home_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CellPage extends StatelessWidget {
  const CellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CellCubit cellCubit = BlocProvider.of<CellCubit>(context);

    return Scaffold(
        floatingActionButton: BlocConsumer<CellCubit, CellState>(
          listener: (context, state) {
            if (state.status == CellStatus.stoppedRent) {
              final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
              homeCubit.loadRentedLockerCells();
              Navigator.of(context).pop();
            }
            if (state.status == CellStatus.inUse) {
              cellCubit.startLoadingLeafData();
            }
          },
          buildWhen: (previous, current) => current.status != CellStatus.inUseLoadingLeafData,
          builder: (context, state) {
            if (state.status == CellStatus.inUse) {
              return SpeedDial(
                animatedIcon: AnimatedIcons.menu_close,
                children: [
                  SpeedDialChild(
                    child: const Icon(Icons.cancel),
                    label: 'Concludi affitto',
                    onTap: () {
                      showAlertDialog(
                        context,
                        "Sei sicuro di voler interrompere l'affitto della cella?",
                        cellCubit.stopRentCell,
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.stop_circle),
                    label: 'Termina coltivazione',
                    onTap: () {
                      showAlertDialog(
                        context,
                        "Sei sicuro di voler terminare la coltivazione?",
                        cellCubit.endCultivation,
                      );
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.lock_open),
                    label: 'Apri cella',
                    onTap: () {
                      showAlertDialog(
                        context,
                        "Sei sicuro di voler aprire la cella?",
                        cellCubit.openCell,
                      );
                    },
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        appBar: AppBar(
          leading: BackButton(onPressed: () {
            cellCubit.stopTimer();
            Navigator.of(context).pop();
          }),
          title: BlocBuilder<CellCubit, CellState>(
            buildWhen: (previous, current) => current.status != CellStatus.inUseLoadingLeafData,
            builder: (context, state) {
              if (state.status == CellStatus.empty || state.status == CellStatus.inUse) {
                return Text(
                  " ${state.lockerLocation}: Cella ${state.numericId}",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontSize: 18),
                  textAlign: TextAlign.start,
                );
              } else {
                return Container();
              }
            },
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<CellCubit, CellState>(
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    cellCubit.loadCellInfo();
                  },
                  child: const Icon(Icons.refresh, color: Colors.white),
                );
              },
            )
          ],
        ),
        body: BlocBuilder<CellCubit, CellState>(
          builder: (context, state) {
            if (state.status == CellStatus.emptyCellOpened) {
              return Column(children: [SizedBox(height: 600, child: StepperExample(cellCubit: cellCubit))]);
            } else {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder<CellCubit, CellState>(
                      buildWhen: (previous, current) => current.status != CellStatus.inUseLoadingLeafData,
                      builder: (context, state) {
                        if (state.status == CellStatus.empty) {
                          return Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))],
                                  borderRadius: const BorderRadius.all(Radius.circular(15))),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              margin: const EdgeInsets.all(3),
                              child: Column(
                                children: const [
                                  Text(
                                    "Nessuna coltivazione in corso",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "Per favore apri la cella per iniziare il processo di scelta delle sementi",
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ));
                        }

                        if (state.status == CellStatus.inUse) {
                          return Column(
                            children: [
                              Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))],
                                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                  margin: const EdgeInsets.all(3),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/microgreen.png'),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${state.cellInfo['seed']?['name']}",
                                            textScaleFactor: 1.4,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "Giorno di crescita: ${((DateTime.now().millisecondsSinceEpoch - double.parse(state.cellInfo['rent'][0]['start'])) / 84000000).ceil() - 1}/${state.cellInfo['seed']['esimated_growth_time']}",
                                            textScaleFactor: 1.2,
                                          )
                                        ],
                                      )
                                    ],
                                  )),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                    width: 250,
                                    height: 180,
                                    child: BlocBuilder<CellCubit, CellState>(
                                      builder: (context, state) {
                                        if (state.status == CellStatus.inUseLoadingLeafData) {
                                          var cellData = state.cellData;
                                          List<FlSpot> spotTemp = [];
                                          List<FlSpot> spotEc = [];
                                          List<FlSpot> spotPh = [];
                                          var tempData = cellData['values']['t'];
                                          var ecData = cellData['values']['ec'];
                                          var phData = cellData['values']['ph'];

                                          for (var i = 0; i < tempData.length; i++) {
                                            spotTemp.add(FlSpot(i.toDouble(), tempData[i]));
                                          }
                                          for (var i = 0; i < ecData.length; i++) {
                                            spotEc.add(FlSpot(i.toDouble(), ecData[i]));
                                          }
                                          for (var i = 0; i < phData.length; i++) {
                                            spotPh.add(FlSpot(i.toDouble(), phData[i]));
                                          }

                                          return LineChart(
                                            LineChartData(
                                                titlesData: FlTitlesData(
                                                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                                ),
                                                borderData: FlBorderData(show: false),
                                                lineBarsData: [
                                                  LineChartBarData(color: Colors.orange[800], spots: [...spotTemp]),
                                                  LineChartBarData(spots: [...spotEc]),
                                                  LineChartBarData(color: Colors.amber, spots: [...spotPh]),
                                                ]),
                                          );
                                        } else {
                                          return Container();
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange[800],
                                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))],
                                            borderRadius: const BorderRadius.all(Radius.circular(15))),
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          "Temp",
                                          textScaleFactor: 1.8,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.cyan[500],
                                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))],
                                            borderRadius: const BorderRadius.all(Radius.circular(15))),
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          "EC",
                                          textScaleFactor: 1.8,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.amber,
                                            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))],
                                            borderRadius: const BorderRadius.all(Radius.circular(15))),
                                        padding: const EdgeInsets.all(8),
                                        child: const Text(
                                          "PH",
                                          textScaleFactor: 1.8,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                            ],
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    BlocBuilder<CellCubit, CellState>(builder: (context, state) {
                      if (state.status == CellStatus.empty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await cellCubit.openCell();
                              },
                              child: const Text(
                                "Apri cella",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await cellCubit.stopRentCell();
                              },
                              child: const Text(
                                "Concludi affitto",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class SeedGrid extends StatelessWidget {
  const SeedGrid({
    super.key,
    required this.cellCubit,
  });

  final CellCubit cellCubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: BlocBuilder<CellCubit, CellState>(
        builder: (context, state) {
          List<Widget> seeds = [];
          for (var seed in state.seeds) {
            seeds.add(GestureDetector(
              onTap: () {
                cellCubit.selectSeed(seed['id']);
              },
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: state.selectedSeedId == seed['id'] ? Colors.grey[200] : Colors.white,
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))],
                      borderRadius: const BorderRadius.all(Radius.circular(15))),
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  margin: const EdgeInsets.all(3),
                  child: Column(
                    children: [
                      Text(seed['name']),
                      Expanded(child: Image.asset('assets/images/microgreen.png')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [const Icon(Icons.access_time), Text("${seed['esimated_growth_time']}")],
                      ),
                    ],
                  )),
            ));
          }
          return GridView.count(
            padding: const EdgeInsets.only(right: 8),
            crossAxisCount: 3,
            children: [...seeds],
          );
        },
      ),
    );
  }
}

class StepperExample extends StatefulWidget {
  const StepperExample({super.key, required this.cellCubit});
  final CellCubit cellCubit;
  @override
  // ignore: no_logic_in_create_state
  State<StepperExample> createState() => _StepperExampleState(cellCubit: cellCubit);
}

class _StepperExampleState extends State<StepperExample> {
  _StepperExampleState({required this.cellCubit});
  int _index = 0;
  bool lastField = false;
  final CellCubit cellCubit;

  @override
  Widget build(BuildContext context) {
    return Stepper(
      type: StepperType.horizontal,
      currentStep: _index,
      controlsBuilder: (context, details) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: lastField
                ? Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          cellCubit.startCultivation();
                          final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
                          homeCubit.loadRentedLockerCells();
                        },
                        style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                        child: const Text("Avvia coltivazione"),
                      ),
                      TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text(
                            "Indietro",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  )
                : Row(
                    children: [
                      ElevatedButton(
                        onPressed: cellCubit.state.selectedSeedId == '' ? null : details.onStepContinue,
                        style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                        child: const Text("Successivo"),
                      ),
                      TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text(
                            "Annulla",
                            style: TextStyle(color: Colors.black),
                          ))
                    ],
                  ));
      },
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
            if (_index == 1) {
              lastField = true;
            } else {
              lastField = false;
            }
          });
        } else {
          cellCubit.cancelSeedSelection();
        }
      },
      onStepContinue: () {
        if (_index <= 0) {
          setState(() {
            _index += 1;
            if (_index == 1) {
              lastField = true;
            } else {
              lastField = false;
            }
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },
      steps: <Step>[
        Step(
          state: _index > 0 ? StepState.complete : StepState.indexed,
          title: const Text('Step 1: seleziona seme'),
          content: Container(
            alignment: Alignment.centerLeft,
            child: SeedGrid(
              cellCubit: cellCubit,
            ),
          ),
        ),
        Step(
          state: _index > 1 ? StepState.complete : StepState.indexed,
          title: const Text('Step 2: avvia'),
          content: Column(
            children: const [
              Text(
                "Clicca il pulsante per avviare la coltivazione",
                textScaleFactor: 1.2,
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ],
    );
  }
}

showAlertDialog(BuildContext context, message, action) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: const Text("Annulla"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Continua"),
    onPressed: () async {
      await action();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(message),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
