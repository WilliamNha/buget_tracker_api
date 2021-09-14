// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:budget_tracker_api/models/budget_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BudgetController extends GetxController {
  var isLoading = false.obs;
  var budgetItem = BudgetItem().obs;
  static const String _baseUrl = 'https://api.notion.com/v1/';

  Future<void> getItems() async {
    isLoading(true);

    try {
      final url =
          '${_baseUrl}databases/${dotenv.env['NOTION_DATABASE_ID']}/query';

      final response = await http.post(Uri.parse(url), headers: {
        HttpHeaders.authorizationHeader:
            'Bearer ${dotenv.env['NOTION_API_KEY']}',
        'Notion-Version': '2021-05-13',
      });

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        print('Response data : $responseJson');
        budgetItem.value = BudgetItem.fromJson(responseJson);
      } else if (response.statusCode == 400) {
        Get.snackbar(
          "Error",
          "Page Not Found",
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(20.0),
        );
      }
    } catch (e) {
      print("===========error In catch get language=========:$e");
    } finally {
      isLoading(false);
    }
  }
}
