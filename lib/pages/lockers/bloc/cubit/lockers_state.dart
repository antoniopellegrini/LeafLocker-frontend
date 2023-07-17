part of 'lockers_cubit.dart';

enum LockersStatus { initial, loading, loaded, error }

class LockersState extends Equatable {
  const LockersState({this.status = LockersStatus.initial, this.lockerList = const []});

  final LockersStatus status;
  final List<dynamic> lockerList;

  LockersState copyWith({LockersStatus? status, List? lockerList}) {
    return LockersState(
      status: status ?? this.status,
      lockerList: lockerList ?? this.lockerList,
    );
  }

  @override
  List<Object> get props => [status, lockerList];
}
