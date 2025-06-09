import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: l10n.budget_amount),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.form_amount_required;
              }
              if (double.tryParse(value) == null) {
                return l10n.form_amount_number;
              }
              if (double.parse(value) <= 0) {
                return l10n.form_amount_positive;
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: periodType,
            items: [
              DropdownMenuItem(
                  value: 'DAILY', child: Text(l10n.budget_period_daily)),
              DropdownMenuItem(
                  value: 'WEEKLY', child: Text(l10n.budget_period_weekly)),
              DropdownMenuItem(
                  value: 'MONTHLY', child: Text(l10n.budget_period_monthly)),
            ],
            onChanged: onPeriodChanged,
            decoration: InputDecoration(labelText: l10n.budget_period),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSave,
              child: Text(l10n.budget_save),
            ),
          ),
        ],
      ),
    );
  }
}