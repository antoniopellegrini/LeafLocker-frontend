import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_app/repository/cell_repository.dart';

part 'cell_state.dart';

class CellCubit extends Cubit<CellState> {
  CellCubit({required CellRepository cellRepository})
      : _cellRepository = cellRepository,
        super(const CellState(status: CellStatus.initial));

  final CellRepository _cellRepository;
  Timer? _timer;

  void startTimer() {
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 10), (_) {
        getCellInfoLeaf();
      });
    }
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() async {
    stopTimer();
    super.close();
  }

  Future<void> loadCellInfo() async {
    var res = await _cellRepository.getCellInfo(state.cellId);
    if (res?.statusCode == 200) {
      if (res.data['cell']['status'] == 'empty') {
        emit(state.copyWith(status: CellStatus.empty, cellInfo: res.data['cell'], seeds: res.data['seeds']));
      }
      if (res.data['cell']['status'] == 'in_use') {
        emit(state.copyWith(status: CellStatus.inUse, cellInfo: res.data['cell']));
      }
    } else {
      emit(state.copyWith(status: CellStatus.error));
    }
  }

  Future<void> loadInitialState(String cellId, String cellNumericId, String lockerLocation) async {
    emit(CellState(status: CellStatus.initial, cellId: cellId, numericId: cellNumericId, lockerLocation: lockerLocation));
  }

  Future<void> selectSeed(String seedId) async {
    emit(state.copyWith(selectedSeedId: state.selectedSeedId == seedId ? '' : seedId));
  }

  Future<void> openCell() async {
    var res = await _cellRepository.openCell(state.cellId);

    if (res?.statusCode == 200) {
      if (state.status == CellStatus.inUse) {}
      if (state.status == CellStatus.empty) {
        emit(state.copyWith(status: CellStatus.emptyCellOpened));
      }
    } else {
      emit(state.copyWith(status: CellStatus.error));
    }
  }

  Future<void> cancelSeedSelection() async {
    emit(state.copyWith(status: CellStatus.empty));
  }

  Future<void> startCultivation() async {
    var res = await _cellRepository.startCultuvation(state.cellId, state.selectedSeedId);
    if (res?.statusCode == 200) {
      emit(state.copyWith(status: CellStatus.inUse, cellInfo: res.data));
    } else {
      emit(state.copyWith(status: CellStatus.error));
    }
  }

  Future<void> endCultivation() async {
    var res = await _cellRepository.endCultivation(state.cellId);
    if (res?.statusCode == 200) {
      stopTimer();
      emit(state.copyWith(
        status: CellStatus.empty,
        selectedSeedId: '',
      ));
    }
  }

  Future<void> stopRentCell() async {
    var res = await _cellRepository.stopRentCell(state.cellId);
    if (res?.statusCode == 200) {
      stopTimer();
      emit(const CellState(status: CellStatus.stoppedRent));
    }
  }

  Future<void> startLoadingLeafData() async {
    startTimer();
  }

  Future<void> getCellInfoLeaf() async {
    // var res = await _cellRepository.getCellInfoLeaf(state.cellInfo['leaf_cell_id'], state.cellInfo['leaf_cell_token']);
    var res = await _cellRepository.getCellInfoLeaf(state.cellInfo['leaf_device_id'], state.cellInfo['rent'][0]['leaf_cell_token']);
    if (res?.statusCode == 200) {
      emit(state.copyWith(status: CellStatus.inUseLoadingLeafData, cellData: res?.data));
    }
  }
}
