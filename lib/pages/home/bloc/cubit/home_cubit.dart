import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fe_app/repository/user_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(const HomeState(status: HomeStatus.inital));

  final UserRepository _userRepository;

  Future<void> loadRentedLockerCells() async {
    var res = await _userRepository.getRentedLockersCellsList();
    if (res.statusCode == 200) {
      emit(state.copyWith(status: HomeStatus.listLoaded, rentedLockerCells: res.data));
    }
  }

  Future<void> loadInitialState() async {
    emit(const HomeState(status: HomeStatus.inital));
  }
}
