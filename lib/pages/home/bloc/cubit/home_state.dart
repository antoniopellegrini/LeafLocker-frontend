part of 'home_cubit.dart';

enum HomeStatus { inital, listLoaded }

class HomeState extends Equatable {
  const HomeState({this.status = HomeStatus.inital, this.rentedLockerCells = const []});

  final HomeStatus status;
  final List rentedLockerCells;

  HomeState copyWith({HomeStatus? status, List? rentedLockerCells}) {
    return HomeState(status: status ?? this.status, rentedLockerCells: rentedLockerCells ?? this.rentedLockerCells);
  }

  @override
  List<Object> get props => [status, rentedLockerCells];
}
