import 'package:flutter/cupertino.dart';
import 'package:moneytama/domain/entity/operation.dart';

class RecentOperationsList extends StatefulWidget {
  const RecentOperationsList({super.key});

  @override
  State<StatefulWidget> createState() => RecentOperationListState();
}

class RecentOperationListState extends State<RecentOperationsList> {
  late List<Operation> operations;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          operations.isEmpty
              ? const Center(child: Text("No operations yet!"))
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

  const OperationItem({super.key, required this.operation});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
