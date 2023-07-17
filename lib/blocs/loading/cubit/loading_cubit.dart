import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

part 'loading_state.dart';

class LoadingCubit extends Cubit<LoadingState> {
  LoadingCubit() : super(const LoadingState(status: LoadingStatus.inital));

  Future<void> load() async {
    emit(state.copyWith(status: LoadingStatus.loading));
  }

  Future<void> stopLoading() async {
    emit(state.copyWith(status: LoadingStatus.notLoading));
  }

  Future<void> showError(response) async {
    emit(state.copyWith(status: LoadingStatus.error, error: response.data['type'], message: response.data['message']));
  }

  Future<void> showErrorUnreachable() async {
    emit(state.copyWith(status: LoadingStatus.error, error: 'unreachable', message: "Can't reach the server"));
  }
}
