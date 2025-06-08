import 'package:flutter/material.dart';

class BudgetForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController amountController;
  final String periodType;
  final ValueChanged<String?> onPeriodChanged;
  final VoidCallback onSave;

  const BudgetForm({
    super.key,
    required this.formKey,
    required this.amountController,
    required this.periodType,
    required this.onPeriodChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Сумма, ₽'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите сумму';
              }
              if (double.tryParse(value) == null) {
                return 'Введите корректное число';
              }
              if (double.parse(value) <= 0) {
                return 'Сумма должна быть больше нуля';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: periodType,
            items: const [
              DropdownMenuItem(value: 'DAILY', child: Text('День')),
              DropdownMenuItem(value: 'WEEKLY', child: Text('Неделя')),
              DropdownMenuItem(value: 'MONTHLY', child: Text('Месяц')),
            ],
            onChanged: onPeriodChanged,
            decoration: const InputDecoration(labelText: 'Период'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              child: const Text('Сохранить'),
            ),
          ),
        ],
      ),
    );
  }
}
