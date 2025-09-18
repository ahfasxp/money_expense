import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_expense/app/app.bottomsheets.dart';
import 'package:money_expense/app/app.locator.dart';
import 'package:money_expense/enum/category_enum.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class AddExpenseViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();

  final nameController = TextEditingController();
  final categoryController = TextEditingController();
  final dateController = TextEditingController();
  final amountController = TextEditingController();

  CategoryEnum? _selectedCategory = CategoryEnum.food;
  CategoryEnum? get selectedCategory => _selectedCategory;

  void init() {
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
      final formattedValue = _formatCurrency(numericValue);

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

  bool get isFormValid {
    return nameController.text.trim().isNotEmpty &&
        categoryController.text.trim().isNotEmpty &&
        dateController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty;
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
      dateController.text = _formatDateIndonesian(selectedDate);
      rebuildUi();
    }
  }

  void saveExpense() {
    if (isFormValid) {
      // Implementasi save expense
      print('Saving expense...');
      print('Name: ${nameController.text}');
      print('Category: ${_selectedCategory?.label}');
      print('Date: ${dateController.text}');
      print('Amount: ${amountController.text}');

      // Navigate back or show success message
      back();
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
