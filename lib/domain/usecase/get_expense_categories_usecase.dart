class GetExpenseCategoriesUseCase {
  Future<List<String>> execute() async {
    return[
      'food',
      'transport',
      'medicine',
      'education',
      'beauty',
      'entertainment',
      'money transfers',
    ];
  }
}
