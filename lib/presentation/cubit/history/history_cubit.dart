import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/domain/usecase/get_last_operations_usecase.dart';

import '../../../domain/entity/operation.dart';
import '../../../domain/usecase/remove_operation_usecase.dart';
import '../../../tools/logger.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetLastOperationsUseCase getLastOperationsUseCase;
  final RemoveOperationUseCase removeOperationUseCase;

  HistoryCubit({required this.getLastOperationsUseCase,
    required this.removeOperationUseCase,
  }) : super(HistoryLoading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    try {
      final operations = await getLastOperationsUseCase.execute();
      emit(HistoryInfo(operations: operations));
    } catch (error) {
      logger.severe('Error fetching history: $error');
      emit(HistoryError());
    }
  }


  Future<void> removeOperation(Operation operation) async {
    try {
      await removeOperationUseCase.execute(operation);
      logger.info('Operation removed successfully');
      loadHistory();
    } catch (error) {
      logger.severe('Error removing operation: $error');
      emit(HistoryError());
    }
  }
}
