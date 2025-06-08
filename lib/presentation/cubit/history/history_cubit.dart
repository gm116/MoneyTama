import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/operation.dart';
import '../../../tools/logger.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryLoading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    try {
      final operations = [
        // todo usecase
        Expense(planned: true, category: "aaa", sum: 100, timestamp: DateTime.now().subtract(Duration(days: 20)), description: "aaa"),
        Expense(planned: false, category: "bbb", sum: 200, timestamp: DateTime.now().subtract(Duration(days: 300)), description: "bbb"),
        Income(category: "ccc", sum: 300, timestamp: DateTime.now().subtract(Duration(days: 2)), description: "ccc"),
        Expense(planned: true, category: "ccc", sum: 400, timestamp: DateTime.now().subtract(Duration(days: 3)), description: "ddd"),
        Income(category: "ccc", sum: 500, timestamp: DateTime.now().subtract(Duration(days: 4)), description: "eee"),
        Expense(planned: false, category: "ccc", sum: 600, timestamp: DateTime.now().subtract(Duration(days: 5)), description: "fff"),
      ];
      emit(HistoryInfo(operations: operations));
    } catch (error) {
      logger.severe('Error fetching history: $error');
      emit(HistoryError());
    }
  }
}
