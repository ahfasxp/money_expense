import 'package:flutter/foundation.dart';
import 'package:money_expense/models/expense_model.dart';
import 'package:money_expense/services/database_service.dart';

class ExpenseService {
  final DatabaseService _databaseService = DatabaseService();

  // Add expense
  Future<bool> addExpense({
    required String name,
    required String category,
    required String date,
    required int amount,
  }) async {
    try {
      final expense = ExpenseModel(
        name: name,
        category: category,
        date: date,
        amount: amount,
        createdAt: DateTime.now(),
      );

      final id = await _databaseService.insertExpense(expense);
      return id > 0;
    } catch (e) {
      debugPrint('Error adding expense: $e');
      return false;
    }
  }

  // Get today's total amount
  Future<int> getTodayTotalAmount() async {
    try {
      return await _databaseService.getTodayTotalAmount();
    } catch (e) {
      debugPrint('Error getting today total amount: $e');
      return 0;
    }
  }

  // Get this month's total amount
  Future<int> getThisMonthTotalAmount() async {
    try {
      return await _databaseService.getThisMonthTotalAmount();
    } catch (e) {
      debugPrint('Error getting this month total amount: $e');
      return 0;
    }
  }

  // Get today's expenses
  Future<List<ExpenseModel>> getTodayExpenses() async {
    try {
      return await _databaseService.getTodayExpenses();
    } catch (e) {
      debugPrint('Error getting today expenses: $e');
      return [];
    }
  }

  // Get yesterday's expenses
  Future<List<ExpenseModel>> getYesterdayExpenses() async {
    try {
      return await _databaseService.getYesterdayExpenses();
    } catch (e) {
      debugPrint('Error getting yesterday expenses: $e');
      return [];
    }
  }

  // Get category totals
  Future<Map<String, int>> getCategoryTotals() async {
    try {
      return await _databaseService.getCategoryTotals();
    } catch (e) {
      debugPrint('Error getting category totals: $e');
      return {};
    }
  }
}
