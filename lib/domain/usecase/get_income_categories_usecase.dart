class GetIncomeCategoriesUseCase {
  Future<List<String>> execute() async {
    return [
      'salary',
      'money transfers',
      'estate incomes',
      'payments',
      'deposit payments',
    ];
  }
}
