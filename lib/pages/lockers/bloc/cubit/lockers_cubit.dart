import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_app/repository/locker_repository.dart';

part 'lockers_state.dart';

class LockersCubit extends Cubit<LockersState> {
  LockersCubit({required LockerRepository lockerRepository})
      : _lockerRepository = lockerRepository,
        super(const LockersState(status: LockersStatus.initial));

  final LockerRepository _lockerRepository;

  Future<void> loadLockerList() async {
    var res = await _lockerRepository.getLockersList();

    if (res?.statusCode == 200) {
      emit(state.copyWith(status: LockersStatus.loaded, lockerList: res.data));
    }
  }

  Future<void> loadInitialState() async {
    emit(const LockersState(status: LockersStatus.initial));
  }
}
