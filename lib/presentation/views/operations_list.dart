import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneytama/domain/entity/operation.dart';

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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child:
          operations.isEmpty
              ? const Center(child: Text("Пока нет операций!"))
              : ListView.builder(
                itemCount: operations.length,
                itemBuilder: (context, index) {
                  final op = operations[index];
                  return OperationItem(operation: op);
                },
              ),
    );
  }
}

class OperationItem extends StatefulWidget {
  final Operation operation;
  final bool showDeleteButton;
  final Function? onDelete;

  const OperationItem(
      {super.key, required this.operation, this.showDeleteButton = false, this.onDelete});

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
        ? Colors.green.shade100
        : (isExpense ? Colors.red.shade100 : Colors.grey.shade200);
    final String formattedSum =
        "${isIncome ? '+ ' : '- '}${op.sum.toStringAsFixed(2)}";

    final String formattedDate = DateFormat.yMMMd().add_Hm().format(
      op.timestamp,
    );

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formattedSum,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (category.isNotEmpty)
                            Text(
                              category,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black87),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            op.description.isEmpty ? "" : op.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
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
