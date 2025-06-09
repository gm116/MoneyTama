import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

import '/domain/entity/operation.dart';

Future<void> exportOperationsToCsv(List<Operation> operations, BuildContext context) async {
  List<List<dynamic>> rows = [
    ['Дата', 'Тип', 'Категория', 'Сумма', 'Описание', 'Запланировано'],
    ...operations.map((op) {
      String type = op is Income ? 'Доход' : 'Расход';
      String category = op is Income
          ? op.category
          : op is Expense
          ? op.category
          : '';
      String planned = op is Expense ? (op.planned ? 'Да' : 'Нет') : '';
      return [
        op.timestamp.toIso8601String(),
        type,
        category,
        op.sum,
        op.description,
        planned,
      ];
    }),
  ];

  final csv = const ListToCsvConverter().convert(rows);
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/operations_export.csv';
  final file = File(path);
  await file.writeAsString(csv);

  final box = context.findRenderObject() as RenderBox?;

  final result = await SharePlus.instance.share(
    ShareParams(
      files: [XFile(path)],
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : null,
    ),
  );
}