part of 'cells_cubit.dart';

enum CellsStatus { initial, loading, loaded, error }

class CellsState extends Equatable {
  const CellsState({
    this.status = CellsStatus.initial,
    this.cellsList = const [],
    this.lockerId = '',
  });

  final CellsStatus status;
  final String lockerId;
  final List<dynamic> cellsList;

  CellsState copyWith({
    CellsStatus? status,
    List? cellsList,
    String? lockerId,
  }) {
    return CellsState(
      status: status ?? this.status,
      cellsList: cellsList ?? this.cellsList,
      lockerId: lockerId ?? this.lockerId,
    );
  }

  @override
  List<Object> get props => [status, cellsList, lockerId];
}
