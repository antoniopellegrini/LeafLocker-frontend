import 'package:fe_app/pages/cells/bloc/cubit/cells_cubit.dart';
import 'package:fe_app/pages/home/bloc/home_cubit.dart';
import 'package:fe_app/pages/rent_cell/bloc/cubit/rent_cell_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class RentCellPage extends StatelessWidget {
  const RentCellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final RentCellCubit rentCellCubit = BlocProvider.of<RentCellCubit>(context);

    return BlocListener<RentCellCubit, RentCellState>(
      listener: (context, state) {
        if (state.status == RentCellStatus.rented) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Cella affittata con successo'),
            backgroundColor: Colors.teal,
          ));

          final HomeCubit homeCubit = BlocProvider.of<HomeCubit>(context);
          homeCubit.loadRentedLockerCells();
          Navigator.popUntil(context, ModalRoute.withName('/homepage'));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Affitta cella',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<CellsCubit, CellsState>(
              builder: (context, state) {
                if (state.status == CellsStatus.loaded) {
                  return TextButton(
                    onPressed: () {
                      rentCellCubit.loadCellPlants(rentCellCubit.state.cellId);
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
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    "Semi disponibili",
                    textScaleFactor: 1.3,
                    style: TextStyle(fontWeight: FontWeight.w400),
                    textAlign: TextAlign.start,
                  ),
                  Container(
                    height: 500,
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<RentCellCubit, RentCellState>(
                      builder: (context, state) {
                        List<Widget> seeds = [];
                        for (var seed in state.plants) {
                          seeds.add(Container(
                              height: 56,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 2))],
                                  borderRadius: const BorderRadius.all(Radius.circular(15))),
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                              margin: const EdgeInsets.all(3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset('assets/images/microgreen.png'),
                                  Text(seed['name']),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [const Icon(Icons.access_time), Text("${seed['esimated_growth_time']}")],
                                  ),
                                ],
                              )));
                        }
                        return Scrollbar(
                          thumbVisibility: true,
                          child: ListView(
                            padding: const EdgeInsets.only(right: 10),
                            children: [...seeds],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // BlocBuilder<RentCellCubit, RentCellState>(
              //   builder: (context, state) {
              //     return SleekCircularSlider(
              //       min: 0,
              //       max: 30,
              //       initialValue: 0,
              //       appearance: CircularSliderAppearance(
              //         angleRange: 320,
              //         startAngle: 110,
              //         customColors: CustomSliderColors(
              //           trackColor: Colors.grey[600],
              //           dotColor: Colors.lightGreen[200],
              //           progressBarColor: Colors.lightGreen[500],
              //         ),
              //       ),
              //       onChange: (double value) {
              //         final roundedValue = value.round().toInt();
              //         if (state.rentDays != roundedValue) {
              //           rentCellCubit.updateRentDays(roundedValue);
              //         }
              //       },
              //       innerWidget: (percentage) {
              //         return Center(
              //             child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             const Text("Rent days"),
              //             Text("${percentage.round()}", style: const TextStyle(fontSize: 22)),
              //           ],
              //         ));
              //       },
              //     );
              //   },
              // ),
              ElevatedButton(
                onPressed: () async {
                  await rentCellCubit.rentCell();
                },
                child: const Text('Affitta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
