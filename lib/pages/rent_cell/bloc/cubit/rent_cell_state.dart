part of 'rent_cell_cubit.dart';

enum RentCellStatus { initial, loading, loaded, error, rented }

class RentCellState extends Equatable {
  const RentCellState({this.status = RentCellStatus.initial, this.plants = const [], this.cellId = '', this.rentDays = 0});

  final RentCellStatus status;
  final String cellId;
  final List<dynamic> plants;
  final int rentDays;

  RentCellState copyWith({RentCellStatus? status, List? plants, String? cellId, int? rentDays}) {
    return RentCellState(
      status: status ?? this.status,
      plants: plants ?? this.plants,
      cellId: cellId ?? this.cellId,
      rentDays: rentDays ?? this.rentDays,
    );
  }

  @override
  List<Object> get props => [status, plants, rentDays, cellId];
}
