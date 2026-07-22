import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:no_wait/core/bloc/base_bloc.dart';
import 'package:no_wait/features/home/presentation/cubit/home_state.dart';
import 'package:no_wait/features/home/repository/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(const HomeState());

  Future<void> fetchHomeSummary() async {
    emit(state.copyWith(status: Status.loading, action: HomeAction.fetchSummary));
    final result = await _repository.getHomeSummary();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          message: failure.message,
          failure: failure,
          action: HomeAction.fetchSummary,
        ),
      ),
      (summary) => emit(
        state.copyWith(
          status: Status.success,
          accountStatus: summary.accountStatus,
          shopItProducts: summary.shopItProducts,
          quickAccessServices: summary.quickAccessServices,
          action: HomeAction.fetchSummary,
        ),
      ),
    );
  }
}
