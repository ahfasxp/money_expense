import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:money_expense/app/app.locator.dart';
import 'package:money_expense/app/app.router.dart';
import 'package:money_expense/models/expense_model.dart';
import 'package:money_expense/services/expense_service.dart';
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

  String get todayTotalFormatted => _formatCurrency(_todayTotal);
  String get monthTotalFormatted => _formatCurrency(_monthTotal);

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
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final yesterdayString = _formatDateIndonesian(yesterday);
      _yesterdayExpenses = await _expenseService.getAllExpenses();
      _yesterdayExpenses = _yesterdayExpenses
          .where((expense) =>
              expense.date.contains(yesterdayString.split(',')[1].trim()))
          .toList();

      // Load totals
      _todayTotal = await _expenseService.getTodayTotalAmount();
      _monthTotal = await _expenseService.getThisMonthTotalAmount();

      // Load category totals
      _categoryTotals = await _expenseService.getThisMonthCategoryTotals();
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      _isLoading = false;
      rebuildUi();
    }
  }

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return 'Rp. ${formatter.format(amount)}';
  }

  String _formatDateIndonesian(DateTime date) {
    final dayNames = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    final monthNames = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];

    final dayName = dayNames[date.weekday % 7];
    final monthName = monthNames[date.month];

    return '$dayName, ${date.day} $monthName ${date.year}';
  }

  String getFormattedAmount(int amount) {
    return _formatCurrency(amount);
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

  Future<void> refreshData() async {
    await loadData();
  }
}
