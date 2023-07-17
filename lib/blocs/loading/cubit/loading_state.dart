part of 'loading_cubit.dart';

enum LoadingStatus { inital, loading, notLoading, error }

class LoadingState extends Equatable {
  const LoadingState({this.status = LoadingStatus.inital, this.error = '', this.message = ''});

  final LoadingStatus status;
  final String error;
  final String message;

  LoadingState copyWith({LoadingStatus? status, String? error, String? message}) {
    return LoadingState(status: status ?? this.status, error: error ?? this.error, message: message ?? this.message);
  }

  @override
  List<Object> get props => [status, error, message];
}
