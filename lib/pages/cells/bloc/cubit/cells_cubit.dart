import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_app/repository/locker_repository.dart';
part 'cells_state.dart';

class CellsCubit extends Cubit<CellsState> {
  CellsCubit({required LockerRepository lockerRepository})
      : _lockerRepository = lockerRepository,
        super(const CellsState(status: CellsStatus.initial));

  final LockerRepository _lockerRepository;

  Future<void> loadFreeLockerCells(String lockerId) async {
    var res = await _lockerRepository.getLockerFreeCells(lockerId);

    if (res?.statusCode == 200) {
      emit(state.copyWith(status: CellsStatus.loaded, cellsList: res.data, lockerId: lockerId));
    } else {
      emit(state.copyWith(
        status: CellsStatus.error,
      ));
    }
  }

  Future<void> loadInitialState() async {
    emit(state.copyWith(status: CellsStatus.initial));
  }
}
