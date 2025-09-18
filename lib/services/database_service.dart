import 'package:money_expense/models/expense_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _database;
  static const String tableName = 'expenses';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL,
        amount INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  // Insert expense
  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.insert(tableName, expense.toMap());
  }

  // Get all expenses
  Future<List<ExpenseModel>> getAllExpenses() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return ExpenseModel.fromMap(maps[i]);
    });
  }

  // Get expenses by date
  Future<List<ExpenseModel>> getExpensesByDate(String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return ExpenseModel.fromMap(maps[i]);
    });
  }

  // Get today's expenses
  Future<List<ExpenseModel>> getTodayExpenses() async {
    final today = DateTime.now();
    final todayString =
        '${today.day} ${_getMonthName(today.month)} ${today.year}';
    return await getExpensesByDate(todayString);
  }

  // Get this month's expenses
  Future<List<ExpenseModel>> getThisMonthExpenses() async {
    final db = await database;
    final now = DateTime.now();
    final monthYear = '${_getMonthName(now.month)} ${now.year}';

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'date LIKE ?',
      whereArgs: ['%$monthYear'],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return ExpenseModel.fromMap(maps[i]);
    });
  }

  // Get expenses by category
  Future<List<ExpenseModel>> getExpensesByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return ExpenseModel.fromMap(maps[i]);
    });
  }

  // Update expense
  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await database;
    return await db.update(
      tableName,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // Delete expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get total amount for today
  Future<int> getTodayTotalAmount() async {
    final expenses = await getTodayExpenses();
    int total = 0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  // Get total amount for this month
  Future<int> getThisMonthTotalAmount() async {
    final expenses = await getThisMonthExpenses();
    int total = 0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  // Get total amount by category for this month
  Future<Map<String, int>> getThisMonthCategoryTotals() async {
    final expenses = await getThisMonthExpenses();
    final Map<String, int> categoryTotals = {};

    for (final expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  String _getMonthName(int month) {
    const monthNames = [
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
    return monthNames[month];
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
