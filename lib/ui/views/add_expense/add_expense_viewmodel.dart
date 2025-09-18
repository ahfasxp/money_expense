import 'package:flutter/material.dart';
import 'package:money_expense/app/app.bottomsheets.dart';
import 'package:money_expense/app/app.locator.dart';
import 'package:money_expense/enums/category_enum.dart';
import 'package:money_expense/services/expense_service.dart';
import 'package:money_expense/utils/formatting.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddExpenseViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();
  final _snackbarService = locator<SnackbarService>();
  final _expenseService = locator<ExpenseService>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();

  CategoryEnum? _selectedCategory = CategoryEnum.food;
  CategoryEnum? get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void initialise() {
    // Set initial category value
    categoryController.text = _selectedCategory?.label ?? '';
    _setupListeners();
  }

  void _setupListeners() {
    nameController.addListener(_onFormChanged);
    categoryController.addListener(_onFormChanged);
    dateController.addListener(_onFormChanged);
    amountController.addListener(_onFormChanged);
    amountController.addListener(_onAmountChanged);
  }

  void _onFormChanged() {
    rebuildUi();
  }

  void _onAmountChanged() {
    final text = amountController.text;
    final cursorPosition = amountController.selection.baseOffset;

    // Remove all non-digit characters
    final numericOnly = text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericOnly.isNotEmpty) {
      final numericValue = int.parse(numericOnly);
      final formattedValue = formatCurrency(numericValue);

      // Calculate new cursor position
      final newCursorPosition = _calculateCursorPosition(
        oldText: text,
        newText: formattedValue,
        oldCursorPosition: cursorPosition,
      );

      amountController.value = TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: newCursorPosition),
      );
    } else {
      // If empty, show Rp. 0
      amountController.value = const TextEditingValue(
        text: 'Rp. 0',
        selection: TextSelection.collapsed(offset: 5),
      );
    }
  }

  int _calculateCursorPosition({
    required String oldText,
    required String newText,
    required int oldCursorPosition,
  }) {
    // Simple calculation to maintain cursor position after formatting
    final oldDigitsBeforeCursor = oldText
        .substring(0, oldCursorPosition)
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;

    int newPosition = 4; // Start after "Rp. "
    int digitCount = 0;

    for (int i = 4; i < newText.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(newText[i])) {
        digitCount++;
        if (digitCount >= oldDigitsBeforeCursor) {
          newPosition = i + 1;
          break;
        }
      }
      newPosition = i + 1;
    }

    return newPosition.clamp(0, newText.length);
  }

  bool get isFormValid {
    return nameController.text.trim().isNotEmpty &&
        categoryController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty &&
        !_isLoading;
  }

  void back() {
    _navigationService.back();
  }

  void showCategorySheet() {
    final result = _bottomSheetService.showCustomSheet(
      variant: BottomSheetType.category,
    );

    result.then((value) {
      if (value?.confirmed == true) {
        final category = value?.data as CategoryEnum;
        _selectedCategory = category;
        categoryController.text = category.label;
        rebuildUi();
      }
    });
  }

  Future<void> selectDate() async {
    final BuildContext? context = StackedService.navigatorKey?.currentContext;
    if (context == null) return;

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      dateController.text = formatDateIndonesian(selectedDate);
      rebuildUi();
    }
  }

  int _parseAmount(String amountText) {
    // Remove "Rp. " and any non-digit characters, then parse
    final numericOnly = amountText.replaceAll(RegExp(r'[^0-9]'), '');
    return numericOnly.isNotEmpty ? int.parse(numericOnly) : 0;
  }

  Future<void> saveExpense() async {
    if (!isFormValid) return;

    _isLoading = true;
    rebuildUi();

    try {
      final amount = _parseAmount(amountController.text);

      final success = await _expenseService.addExpense(
        name: nameController.text.trim(),
        category: _selectedCategory?.label ?? '',
        date: dateController.text.trim(),
        amount: amount,
      );

      if (success) {
        _snackbarService.showCustomSnackBar(
          variant: 'success',
          message: 'Pengeluaran berhasil disimpan!',
        );

        // Clear form
        nameController.clear();
        categoryController.clear();
        dateController.clear();
        amountController.clear();
        _selectedCategory = CategoryEnum.food;
        categoryController.text = _selectedCategory?.label ?? '';

        // Navigate back
        back();
      } else {
        _snackbarService.showCustomSnackBar(
          variant: 'error',
          message: 'Gagal menyimpan pengeluaran. Silakan coba lagi.',
        );
      }
    } catch (e) {
      debugPrint('Error saving expense: $e');
      _snackbarService.showCustomSnackBar(
        variant: 'error',
        message: 'Terjadi kesalahan. Silakan coba lagi.',
      );
    } finally {
      _isLoading = false;
      rebuildUi();
    }
  }

  @override
  void dispose() {
    nameController.removeListener(_onFormChanged);
    categoryController.removeListener(_onFormChanged);
    dateController.removeListener(_onFormChanged);
    amountController.removeListener(_onFormChanged);
    amountController.removeListener(_onAmountChanged);

    nameController.dispose();
    categoryController.dispose();
    dateController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
