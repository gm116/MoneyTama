import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/tools/logger.dart';

import '../../../domain/entity/operation.dart';
import '../../../domain/usecase/add_expense_category_usecase.dart';
import '../../../domain/usecase/add_expense_usecase.dart';
import '../../../domain/usecase/add_income_category_usecase.dart';
import '../../../domain/usecase/add_income_usecase.dart';
import '../../../domain/usecase/get_income_categories_usecase.dart';
import '../../../domain/usecase/get_expense_categories_usecase.dart';
import 'operation_state.dart';

class OperationCubit extends Cubit<OperationState> {
  final AddExpenseUseCase addExpenseUseCase;
  final AddIncomeUseCase addIncomeUseCase;
  final GetIncomeCategoriesUseCase getIncomeCategoriesUseCase;
  final GetExpenseCategoriesUseCase getExpenseCategoriesUseCase;
  final AddExpenseCategoryUseCase addExpenseCategoryUseCase;
  final AddIncomeCategoryUseCase addIncomeCategoryUseCase;

  OperationCubit({
    required this.addExpenseUseCase,
    required this.addIncomeUseCase,
    required this.getIncomeCategoriesUseCase,
    required this.getExpenseCategoriesUseCase,
    required this.addExpenseCategoryUseCase,
    required this.addIncomeCategoryUseCase,
  }) : super(OperationLoading()) {
    startIncome();
  }

  Future<void> startExpense() async {
    try {
      final categories = await getExpenseCategoriesUseCase.execute();
      emit(OperationExpense(categories: categories));
    } catch (error) {
      logger.severe('Error fetching expense categories: $error');
      emit(OperationError());
    }
  }

  Future<void> startIncome() async {
    try {
      final categories = await getIncomeCategoriesUseCase.execute();
      emit(OperationIncome(categories: categories));
    } catch (error) {
      logger.severe('Error fetching income categories: $error');
      emit(OperationError());
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      if (state is! OperationExpense) {
        logger.warning('Cannot add expense in non-OperationExpense state');
        return;
      }
      final category = expense.category;
      final categories = (state as OperationExpense).categories;
      emit(OperationLoading());
      if (!categories.contains(category)) {
        logger.info('Adding new expense category: $category');
        await addExpenseCategoryUseCase.execute(category);
      }
      await addExpenseUseCase.execute(expense);
      emit(OperationSuccess());
    } catch (error) {
      emit(OperationError());
    }
  }

  Future<void> addIncome(Income income) async {
    try {
      if (state is! OperationIncome) {
        logger.warning('Cannot add income in non-OperationIncome state, current state: $state');
        return;
      }
      final category = income.category;
      final categories = (state as OperationIncome).categories;
      emit(OperationLoading());
      if (!categories.contains(category)) {
        logger.info('Adding new income category: $category');
        await addIncomeCategoryUseCase.execute(category);
      }
      await addIncomeUseCase.execute(income);
      emit(OperationSuccess());
    } catch (error) {
      emit(OperationError());
    }
  }
}
