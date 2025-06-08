import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/presentation/cubit/history/history_cubit.dart';
import 'package:moneytama/presentation/cubit/history/history_state.dart';
import 'package:moneytama/presentation/views/operations_list.dart';
import 'package:moneytama/tools/logger.dart';

import '../../../domain/entity/operation.dart';
import '../di/di.dart';
import '../views/chart_segment.dart';
import '../views/history_top_block.dart';
import '../views/pie_chart_block.dart';

class HistoryScreen extends StatefulWidget {
  static const String routeName = '/history';
  final Function(int) updateIndex;

  const HistoryScreen({super.key, required this.updateIndex});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  String _selectedPeriod = 'week';
  late List<Operation> _filteredOperations;
  bool _showIncomeDetails = false;
  bool _showExpenseDetails = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HistoryCubit(
            getLastOperationsUseCase: getIt(),
            removeOperationUseCase: getIt(),
          ),
      child: BlocListener<HistoryCubit, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            logger.severe('Error loading history');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ошибка загрузки истории')),
            );
          }
        },
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HistoryInfo) {
              final operations = state.operations;
              _filteredOperations = _filterOperationsByPeriod(operations);

              final incomeData = _getPieChartData(
                _filteredOperations.whereType<Income>().toList(),
              );
              final expenseData = _getPieChartData(
                _filteredOperations.whereType<Expense>().toList(),
              );

              final totalIncome = _filteredOperations
                  .whereType<Income>()
                  .fold<double>(0, (sum, op) => sum + op.sum);
              final totalExpense = _filteredOperations
                  .whereType<Expense>()
                  .fold<double>(0, (sum, op) => sum + op.sum);

              return Column(
                children: [
                  DropdownButton<String>(
                    value: _selectedPeriod,
                    items: const [
                      DropdownMenuItem(value: 'week', child: Text('Неделя')),
                      DropdownMenuItem(value: 'month', child: Text('Месяц')),
                      DropdownMenuItem(value: 'year', child: Text('Год')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedPeriod = value!;
                        _filteredOperations =
                            _filterOperationsByPeriod(operations);
                      });
                    },
                  ),
                  if (!_showIncomeDetails && !_showExpenseDetails)
                    Row(
                      children: [
                        Expanded(
                          child: HistoryTopBlock(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .primaryContainer,
                              onTap: () {
                                setState(() {
                                  _showIncomeDetails = !_showIncomeDetails;
                                  _showExpenseDetails = false;
                                });
                              },
                              total: totalIncome,
                              data: incomeData,
                              title: 'Доходы'
                          ),
                        ),
                        Expanded(
                          child: HistoryTopBlock(
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .tertiaryContainer,
                              onTap: () {
                                setState(() {
                                  _showExpenseDetails = !_showExpenseDetails;
                                  _showIncomeDetails = false;
                                });
                              },
                              total: totalExpense,
                              data: expenseData,
                              title: 'Траты'
                          ),
                        ),
                      ],
                    ),
                  if (_showIncomeDetails)
                    PieChartBlock(
                      title: 'Доходы',
                      data: incomeData,
                      operations: _filteredOperations
                          .whereType<Income>()
                          .toList(),
                      onClose: () {
                        setState(() {
                          _showIncomeDetails = false;
                          _showExpenseDetails = false;
                        });
                      },
                      total: totalIncome,
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .primaryContainer,
                    ),
                  if (_showExpenseDetails)
                    PieChartBlock(
                      title: 'Траты',
                      data: expenseData,
                      operations: _filteredOperations
                          .whereType<Expense>()
                          .toList(),
                      onClose: () {
                        setState(() {
                          _showIncomeDetails = false;
                          _showExpenseDetails = false;
                        });
                      },
                      total: totalExpense,
                      backgroundColor: Theme
                          .of(context)
                          .colorScheme
                          .tertiaryContainer,
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filteredOperations.length,
                      itemBuilder: (context, index) {
                        final operation = _filteredOperations[index];
                        return OperationItem(
                            operation: operation,
                            showDeleteButton: true,
                            onDelete: () {
                              context.read<HistoryCubit>().removeOperation(operation);
                            }
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is HistoryError) {
              return const Center(
                child: Text('Ошибка загрузки истории'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  List<Operation> _filterOperationsByPeriod(List<Operation> operations) {
    final now = DateTime.now();
    return operations.where((operation) {
      final timestamp = operation.timestamp;
      switch (_selectedPeriod) {
        case 'week':
          return timestamp.isAfter(now.subtract(const Duration(days: 7)));
        case 'month':
          return timestamp.isAfter(DateTime(now.year, now.month - 1, now.day));
        case 'year':
          return timestamp.isAfter(DateTime(now.year - 1, now.month, now.day));
        default:
          return true;
      }
    }).toList();
  }

  List<ChartSegment> _getPieChartData(List<Operation> operations) {
    final Map<String, double> categoryTotals = {};
    for (var operation in operations) {
      categoryTotals[_getCategory(operation)] =
          (categoryTotals[_getCategory(operation)] ?? 0) + operation.sum;
    }
    logger.info("categoryTotals: $categoryTotals");
    final res = categoryTotals.entries
        .map((entry) =>
        ChartSegment(
          percentage: (entry.value /
              operations.fold<double>(
                  0, (sum, op) => sum + op.sum)) *
              100,
          color: chartColors[categoryTotals.keys.toList().indexOf(
              entry.key) % chartColors.length],
          category: entry.key,
        ))
        .toList();
    logger.info("pieChartData: $res");
    return res;
  }

  String _getCategory(Operation operation) {
    if (operation is Income) {
      return operation.category;
    } else if (operation is Expense) {
      return operation.category;
    }
    return 'Другое';
  }

  final List<Color> chartColors = [
    Colors.red,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.lightBlue,
    Colors.teal,
    Colors.lightGreen,
    Colors.yellow,
    Colors.orange,
    Colors.brown,
  ];
}
