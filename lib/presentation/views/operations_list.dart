import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moneytama/domain/entity/operation.dart';

import '../cubit/history/history_cubit.dart';
import '../cubit/history/history_state.dart';
import '../di/di.dart';

class RecentOperationsList extends StatefulWidget {
  final int limit;
  final double width;
  final double height;

  const RecentOperationsList({
    super.key,
    required this.limit,
    required this.width,
    required this.height,
  });

  @override
  State<StatefulWidget> createState() => RecentOperationListState();
}

class RecentOperationListState extends State<RecentOperationsList> {
  late List<Operation> operations;

  @override
  void initState() {
    super.initState();
    // TODO get ops with widget.limit
    operations = [
      Income(
        category: "Salary",
        sum: 2000.00,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        description: "Monthly salary",
      ),
      Expense(
        planned: true,
        category: "Food",
        sum: 50.75,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        description: "Grocery shopping",
      ),
      Expense(
        planned: true,
        category: "Food",
        sum: 50.75,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        description: "Grocery shopping",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryCubit>(
      create: (context) {
        final cubit = HistoryCubit(
          getLastOperationsUseCase: getIt(),
          removeOperationUseCase: getIt(),
        );
        cubit.loadHistory();
        return cubit;
      },
      child: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return SizedBox(
              height: widget.height,
              width: widget.width,
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (state is HistoryInfo) {
            final List<Operation> operations = state.operations.sublist(
              0,
              widget.limit + 1,
            );
            return SizedBox(
              height: widget.height,
              width: widget.width,
              child:
                  operations.isEmpty
                      ? const Center(child: Text("Пока нет операций!"))
                      : ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: operations.length,
                        itemBuilder: (context, index) {
                          final op = operations[index];
                          return OperationItem(operation: op);
                        },
                      ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class OperationItem extends StatefulWidget {
  final Operation operation;
  final bool showDeleteButton;
  final Function? onDelete;

  const OperationItem({
    super.key,
    required this.operation,
    this.showDeleteButton = false,
    this.onDelete,
  });

  @override
  State<StatefulWidget> createState() => OperationItemState();
}

class OperationItemState extends State<OperationItem> {
  @override
  Widget build(BuildContext context) {
    final Operation op = widget.operation;
    final bool isIncome = op is Income;
    final bool isExpense = op is Expense;

    String category = "";
    if (isIncome) {
      category = op.category;
    } else if (isExpense) {
      category = op.category;
    }

    final Color backgroundColor =
        isIncome
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.tertiaryContainer;
    final String formattedSum =
        "${isIncome ? '+ ' : '- '}${op.sum.toStringAsFixed(2)}";
    final String formattedDate = DateFormat.MMMd("RU_ru").format(op.timestamp);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            formattedSum,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isIncome ? Colors.purple : Colors.red,
                            ),
                          ),
                          if (category.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          op.description,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      if (widget.showDeleteButton)
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (widget.onDelete != null) {
                              widget.onDelete!();
                            }
                          },
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
