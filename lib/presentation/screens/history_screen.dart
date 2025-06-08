import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/presentation/cubit/history/history_cubit.dart';
import 'package:moneytama/presentation/cubit/history/history_state.dart';
import 'package:moneytama/presentation/views/analytical_pie_chart.dart';
import 'package:moneytama/tools/logger.dart';

import '../../../domain/entity/operation.dart';

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
      create: (_) => HistoryCubit(),
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
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showIncomeDetails = !_showIncomeDetails;
                              _showExpenseDetails = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(16.0),
                            color: Colors.green[100],
                            child: Column(
                              children: [
                                Text(
                                  '₽$totalIncome',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Доходы'),
                                _buildSegmentedLine(incomeData),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showExpenseDetails = !_showExpenseDetails;
                              _showIncomeDetails = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(16.0),
                            color: Colors.red[100],
                            child: Column(
                              children: [
                                Text(
                                  '₽$totalExpense',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text('Траты'),
                                _buildSegmentedLine(expenseData),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_showIncomeDetails)
                    _buildPieChartDetails(
                      'Доходы',
                      incomeData,
                      _filteredOperations.whereType<Income>().toList(),
                    ),
                  if (_showExpenseDetails)
                    _buildPieChartDetails(
                      'Траты',
                      expenseData,
                      _filteredOperations.whereType<Expense>().toList(),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _filteredOperations.length,
                      itemBuilder: (context, index) {
                        final operation = _filteredOperations[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              operation is Income
                                  ? 'Доход: ${operation.category}'
                                  : 'Трата: ${(operation as Expense).category}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Описание: ${operation.description}\n'
                                  'Сумма: ${operation.sum}\n'
                                  'Дата: ${operation.timestamp
                                  .toLocal()
                                  .toString()
                                  .split(' ')[0]}',
                            ),
                            trailing: operation is Expense && operation.planned
                                ? const Icon(
                                Icons.event_note, color: Colors.blue)
                                : null,
                          ),
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

  Widget _buildSegmentedLine(List<PieChartSegment> data) {
    return Row(
      children: data.map((segment) {
        return Expanded(
          flex: (segment.percentage * 100).toInt(),
          child: Container(
            height: 8,
            color: segment.color,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPieChartDetails(
      String title, List<PieChartSegment> data, List<Operation> operations) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _showIncomeDetails = false;
                  _showExpenseDetails = false;
                });
              },
            ),
          ],
        ),
        SizedBox(
          height: 200,
          width: 200,
          child: AnalyticalPieChart(data: data),
        ),
        ...data.map((segment) {
          final operation = operations.firstWhere(
                (op) => _getCategory(op) == segment.category.toString()
          );
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${_getCategory(operation)}: ${segment.percentage.toStringAsFixed(2)}% (${operation.sum} ₽)',
            ),
          );
        }),
      ],
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

  List<PieChartSegment> _getPieChartData(List<Operation> operations) {
    final Map<String, double> categoryTotals = {};
    for (var operation in operations) {
      categoryTotals[_getCategory(operation)] =
          (categoryTotals[_getCategory(operation)] ?? 0) + operation.sum;
    }
    logger.info("categoryTotals: $categoryTotals");
    final res = categoryTotals.entries
        .map((entry) =>
        PieChartSegment(
          percentage: (entry.value /
              operations.fold<double>(
                  0, (sum, op) => sum + op.sum)) *
              100,
          color: Colors.primaries[categoryTotals.keys.toList().indexOf(
              entry.key) % Colors.primaries.length],
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
    return '';
  }
}
