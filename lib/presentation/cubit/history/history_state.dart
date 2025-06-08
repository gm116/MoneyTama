import 'package:moneytama/domain/entity/operation.dart';

class HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryInfo extends HistoryState {
  final List<Operation> operations;

  HistoryInfo({required this.operations});

  @override
  String toString() {
    return 'HistorySuccess(operations: $operations)';
  }
}

class HistoryError extends HistoryState {}