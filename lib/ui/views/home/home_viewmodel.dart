import 'package:flutter/foundation.dart';
import 'package:money_expense/app/app.locator.dart';
import 'package:money_expense/app/app.router.dart';
import 'package:money_expense/models/expense_model.dart';
import 'package:money_expense/services/expense_service.dart';
import 'package:money_expense/utils/formatting.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _expenseService = locator<ExpenseService>();

  List<ExpenseModel> _todayExpenses = [];
  List<ExpenseModel> get todayExpenses => _todayExpenses;

  List<ExpenseModel> _yesterdayExpenses = [];
  List<ExpenseModel> get yesterdayExpenses => _yesterdayExpenses;

  int _todayTotal = 0;
  int get todayTotal => _todayTotal;

  int _monthTotal = 0;
  int get monthTotal => _monthTotal;

  Map<String, int> _categoryTotals = {};
  Map<String, int> get categoryTotals => _categoryTotals;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get todayTotalFormatted => formatCurrency(_todayTotal);
  String get monthTotalFormatted => formatCurrency(_monthTotal);

  void initialise() async {
    await loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    rebuildUi();

    try {
      // Load today's expenses
      _todayExpenses = await _expenseService.getTodayExpenses();

      // Load yesterday's expenses
      _yesterdayExpenses = await _expenseService.getYesterdayExpenses();

      // Load totals
      _todayTotal = await _expenseService.getTodayTotalAmount();
      _monthTotal = await _expenseService.getThisMonthTotalAmount();

      // Load category totals
      _categoryTotals = await _expenseService.getCategoryTotals();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      _isLoading = false;
      rebuildUi();
    }
  }

  String getFormattedAmount(int amount) {
    return formatCurrency(amount);
  }

  // Get the highest category expense for display
  MapEntry<String, int>? get topCategoryExpense {
    if (_categoryTotals.isEmpty) return null;

    var sortedEntries = _categoryTotals.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first;
  }

  void navigateToAddExpenseView() async {
    final result = await _navigationService.navigateToAddExpenseView();

    // Reload data when returning from add expense view
    if (result == true || result == null) {
      await loadData();
    }
  }
}
