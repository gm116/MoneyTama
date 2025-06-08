abstract class OperationState {}

class OperationIncome extends OperationState {
  final List<String> categories;

  OperationIncome({required this.categories});

  @override
  String toString() {
    return 'OperationIncome(categories: $categories)';
  }
}

class OperationExpense extends OperationState {
  final List<String> categories;

  OperationExpense({required this.categories});

  @override
  String toString() {
    return 'OperationExpense(categories: $categories)';
  }
}

class OperationLoading extends OperationState {}

class OperationSuccess extends OperationState {}

class OperationError extends OperationState {}
