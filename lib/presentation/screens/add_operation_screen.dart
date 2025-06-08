import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/presentation/cubit/operation/operation_cubit.dart';
import 'package:moneytama/presentation/cubit/operation/operation_state.dart';
import 'package:moneytama/tools/logger.dart';
import 'package:provider/provider.dart';

import '../../../domain/entity/operation.dart';
import '../di/di.dart';
import '../state/pet_notifier.dart';

class AddOperationScreen extends StatefulWidget {
  static const String routeName = '/add_operation';

  const AddOperationScreen({super.key});

  @override
  State<AddOperationScreen> createState() => _AddOperationScreenState();
}

class _AddOperationScreenState extends State<AddOperationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sumController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;
  bool _isIncome = true;
  List<String> _categories = [];
  bool _isPlanned = false;

  void _clear(bool value) async {
    setState(() {
      _categories = [];
      _isIncome = value;
      _categories = [];
      _selectedCategory = null;
      _selectedDate = null;
      _isPlanned = false;
    });
  }

  void _addCustomCategory() {
    final TextEditingController customCategoryController =
    TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Добавить категорию'),
          content: TextFormField(
            controller: customCategoryController,
            decoration: const InputDecoration(hintText: 'Введите категорию'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _categories.add(customCategoryController.text);
                  _selectedCategory = customCategoryController.text;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitOperation(BuildContext context) {
    PetNotifier notifier = Provider.of<PetNotifier>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      final double sum = double.parse(_sumController.text);
      final String description = _descriptionController.text;
      final String category = _selectedCategory ?? 'Другое';
      final DateTime timestamp = _selectedDate ?? DateTime.now();
      final bool planned = _isPlanned;

      final cubit = context.read<OperationCubit>();
      if (_isIncome) {
        final income = Income(
          category: category,
          sum: sum,
          timestamp: timestamp,
          description: description,
        );
        cubit.addIncome(income);
        notifier.pet.cheerUp(income);
      } else {
        final expense = Expense(
          planned: planned,
          category: category,
          sum: sum,
          timestamp: timestamp,
          description: description,
        );
        cubit.addExpense(expense);
        notifier.pet.disappoint(expense);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          OperationCubit(
            addExpenseUseCase: getIt(),
            addIncomeUseCase: getIt(),
            getIncomeCategoriesUseCase: getIt(),
            getExpenseCategoriesUseCase: getIt(),
            addExpenseCategoryUseCase: getIt(),
            addIncomeCategoryUseCase: getIt(),
          ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Добавить операцию'),
        ),
        body: BlocListener<OperationCubit, OperationState>(
          listener: (context, state) {
            if (state is OperationSuccess) {
              logger.info('Operation added successfully');
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Операция успешно добавлена')),
              );
            } else if (state is OperationError) {
              logger.severe('Error adding operation');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Ошибка при добавлении операции')),
              );
            } else if (state is OperationLoading) {
              logger.info('Loading operation categories...');
            } else if (state is OperationExpense) {
              _categories = state.categories;
              logger.info('Loaded expense categories: $_categories');
            } else if (state is OperationIncome) {
              _categories = state.categories;
              logger.info('Loaded income categories: $_categories');
            }
          },
          child: BlocBuilder<OperationCubit, OperationState>(
            builder: (context, state) {
              if (state is OperationLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ToggleButtons(
                        isSelected: [_isIncome, !_isIncome],
                        onPressed: (index) {
                          _clear(index == 0);
                          if (index == 0) {
                            context.read<OperationCubit>().startIncome();
                          } else {
                            context.read<OperationCubit>().startExpense();
                          }
                        },
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Доход'),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Трата'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _sumController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Стоимость'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите стоимость';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Пожалуйста, введите корректное число';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            labelText: 'Описание'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите описание';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        items: _categories
                            .map((category) =>
                            DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        decoration: const InputDecoration(
                            labelText: 'Категория'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, выберите категорию';
                          }
                          return null;
                        },
                      ),
                      TextButton(
                        onPressed: _addCustomCategory,
                        child: const Text('Добавить категорию'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedDate != null
                              ? 'Дата: ${_selectedDate!
                              .toLocal()
                              .toString()
                              .split(' ')[0]}'
                              : 'Дата не выбрана'),
                          TextButton(
                            onPressed: _pickDate,
                            child: const Text('Выбрать дату'),
                          ),
                        ],
                      ),
                        SizedBox(
                            height: 64,
                        child: Row(
                          children: [
                            if (!_isIncome)
                              Checkbox(
                              value: _isPlanned,
                              onChanged: (value) {
                                setState(() {
                                  _isPlanned = value ?? false;
                                });
                              },
                            ),
                            if (!_isIncome)
                              const Text('Запланированная трата'),
                          ],
                        )
                      ),
                      ElevatedButton(
                        onPressed: () => _submitOperation(context),
                        child: const Text('Сохранить операцию'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
