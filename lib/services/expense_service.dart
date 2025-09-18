import 'package:flutter/widgets.dart';
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

  // Get all expenses
  Future<List<ExpenseModel>> getAllExpenses() async {
    try {
      return await _databaseService.getAllExpenses();
    } catch (e) {
      debugPrint('Error getting all expenses: $e');
      return [];
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

  // Get this month's expenses
  Future<List<ExpenseModel>> getThisMonthExpenses() async {
    try {
      return await _databaseService.getThisMonthExpenses();
    } catch (e) {
      debugPrint('Error getting this month expenses: $e');
      return [];
    }
  }

  // Get expenses by category
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    try {
      return await _databaseService.getExpensesByCategory(category);
    } catch (e) {
      debugPrint('Error getting expenses by category: $e');
      return [];
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

  // Get category totals for this month
  Future<Map<String, int>> getThisMonthCategoryTotals() async {
    try {
      return await _databaseService.getThisMonthCategoryTotals();
    } catch (e) {
      debugPrint('Error getting category totals: $e');
      return {};
    }
  }

  // Update expense
  Future<bool> updateExpense(ExpenseModel expense) async {
    try {
      final result = await _databaseService.updateExpense(expense);
      return result > 0;
    } catch (e) {
      debugPrint('Error updating expense: $e');
      return false;
    }
  }

  // Delete expense
  Future<bool> deleteExpense(int id) async {
    try {
      final result = await _databaseService.deleteExpense(id);
      return result > 0;
    } catch (e) {
      debugPrint('Error deleting expense: $e');
      return false;
    }
  }
}
