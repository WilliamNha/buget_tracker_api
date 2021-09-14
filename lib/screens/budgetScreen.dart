// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace

import 'package:budget_tracker_api/controllers/budget_controller.dart';
import 'package:budget_tracker_api/widgets/spending_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

final _budgetController = Get.put(BudgetController());

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  _BudgetScreenState createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  void initState() {
    _budgetController.getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _budgetController.getItems();
          setState(() {});
        },
        child: Obx(
          () => _budgetController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _budgetController
                                    .budgetItem.value.itemList!.length +
                                1,
                            itemBuilder: (context, index) {
                              final items =
                                  _budgetController.budgetItem.value.itemList!;

                              if (index == 0) {
                                return SpendingChart(
                                    items: _budgetController
                                        .budgetItem.value.itemList!);
                              }
                              final item = items[index - 1];
                              return Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 6.0),
                                    ],
                                    border: Border.all(
                                      width: 2.0,
                                      color: getCategoryColor(item.category!),
                                    )),
                                child: ListTile(
                                  title: Text(item.name!),
                                  subtitle: Text(
                                      '${item.category} * ${DateFormat.yMd().format(item.date!)} '),
                                  trailing: Text(
                                      '-\$${item.price!.toStringAsFixed(2)}'),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Entertainment':
      return Colors.red[400]!;
    case 'Food':
      return Colors.green[400]!;
    case 'Personal':
      return Colors.blue[400]!;
    case 'Transportation':
      return Colors.purple[400]!;
    default:
      return Colors.orange[400]!;
  }
}
