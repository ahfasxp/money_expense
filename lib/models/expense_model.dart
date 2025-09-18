class ExpenseModel {
  final int? id;
  final String name;
  final String category;
  final String date;
  final int amount; // Store amount as integer (in smallest currency unit)
  final DateTime createdAt;

  ExpenseModel({
    this.id,
    required this.name,
    required this.category,
    required this.date,
    required this.amount,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'date': date,
      'amount': amount,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      date: map['date'] ?? '',
      amount: map['amount']?.toInt() ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, name: $name, category: $category, date: $date, amount: $amount, createdAt: $createdAt)';
  }
}
