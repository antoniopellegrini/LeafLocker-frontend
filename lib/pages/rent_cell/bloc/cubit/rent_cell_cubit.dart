import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_app/repository/cell_repository.dart';
part 'rent_cell_state.dart';

class RentCellCubit extends Cubit<RentCellState> {
  RentCellCubit({required CellRepository cellRepository})
      : _cellRepository = cellRepository,
        super(const RentCellState(status: RentCellStatus.initial));

  final CellRepository _cellRepository;

  Future<void> loadCellPlants(String cellId) async {
    var res = await _cellRepository.getCellPlants(cellId);

    if (res?.statusCode == 200) {
      emit(state.copyWith(status: RentCellStatus.loaded, plants: res.data, cellId: cellId));
    } else {
      emit(state.copyWith(status: RentCellStatus.error));
    }
  }

  Future<void> loadInitialState() async {
    emit(const RentCellState(status: RentCellStatus.initial));
  }

  Future<void> updateRentDays(int rentDays) async {
    emit(state.copyWith(rentDays: rentDays));
  }

  Future<void> rentCell() async {
    emit(state.copyWith(status: RentCellStatus.loading));
    var res = await _cellRepository.rentCell(state.cellId, state.rentDays.toString());
    if (res?.statusCode == 200) {
      emit(const RentCellState(status: RentCellStatus.rented));
    } else {
      emit(state.copyWith(status: RentCellStatus.error));
    }
  }
}
