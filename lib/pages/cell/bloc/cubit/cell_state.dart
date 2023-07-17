part of 'cell_cubit.dart';

enum CellStatus {
  initial,
  empty,
  emptyCellOpened,
  inUse,
  inUseLoadingLeafData,
  stoppedRent,
  error,
}

class CellState extends Equatable {
  const CellState(
      {this.status = CellStatus.initial,
      this.seeds = const [],
      this.cellId = '',
      this.numericId = '',
      this.lockerLocation = '',
      this.cellInfo = const {},
      this.selectedSeedId = '',
      this.cellData = const {}});

  final CellStatus status;
  final String cellId;
  final String numericId;
  final String lockerLocation;
  final List<dynamic> seeds;
  final String selectedSeedId;
  final Map cellInfo;
  final Map cellData;

  CellState copyWith({CellStatus? status, List? seeds, String? selectedSeedId, String? cellId, String? numericId, String? lockerLocation, Map? cellInfo, Map? cellData}) {
    return CellState(
        status: status ?? this.status,
        seeds: seeds ?? this.seeds,
        selectedSeedId: selectedSeedId ?? this.selectedSeedId,
        cellId: cellId ?? this.cellId,
        cellInfo: cellInfo ?? this.cellInfo,
        numericId: numericId ?? this.numericId,
        lockerLocation: lockerLocation ?? this.lockerLocation,
        cellData: cellData ?? this.cellData);
  }

  @override
  List<Object> get props => [status, seeds, selectedSeedId, cellId, cellInfo, numericId, lockerLocation, cellData];
}
