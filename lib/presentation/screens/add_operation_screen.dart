import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneytama/presentation/cubit/operation/operation_cubit.dart';
import 'package:moneytama/presentation/cubit/operation/operation_state.dart';
import 'package:moneytama/tools/logger.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          title: Text(AppLocalizations.of(context)!.operation_add_category),
          content: TextFormField(
            controller: customCategoryController,
            decoration: InputDecoration(hintText: AppLocalizations.of(context)!.operation_category),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _categories.add(customCategoryController.text);
                  _selectedCategory = customCategoryController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
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
    final loc = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      final double sum = double.parse(_sumController.text);
      final String description = _descriptionController.text;
      final String category = _selectedCategory ?? loc.operation_category;
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
    final loc = AppLocalizations.of(context)!;
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
          title: Text(loc.operation_add),
        ),
        body: BlocListener<OperationCubit, OperationState>(
          listener: (context, state) {
            if (state is OperationSuccess) {
              logger.info('Operation added successfully');
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.operation_success)),
              );
            } else if (state is OperationError) {
              logger.severe('Error adding operation');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(loc.operation_error)),
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(loc.operation_income),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(loc.operation_expense),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _sumController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: loc.budget_amount),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc.form_amount_required;
                          }
                          if (double.tryParse(value) == null) {
                            return loc.form_amount_number;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                            labelText: loc.form_desc_required),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc.form_desc_required;
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
                        decoration: InputDecoration(
                            labelText: loc.operation_category),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return loc.form_category_required;
                          }
                          return null;
                        },
                      ),
                      TextButton(
                        onPressed: _addCustomCategory,
                        child: Text(loc.operation_add_category),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_selectedDate != null
                              ? '${loc.form_select_date}: ${_selectedDate!
                              .toLocal()
                              .toString()
                              .split(' ')[0]}'
                              : loc.form_date_not_selected),
                          TextButton(
                            onPressed: _pickDate,
                            child: Text(loc.form_select_date),
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
                              Text(loc.operation_planned_expense),
                          ],
                        )
                      ),
                      ElevatedButton(
                        onPressed: () => _submitOperation(context),
                        child: Text(loc.operation_save),
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
