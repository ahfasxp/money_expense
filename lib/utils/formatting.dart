import 'package:intl/intl.dart';

String formatCurrency(int amount) {
  final formatter = NumberFormat('#,###', 'id_ID');
  return 'Rp. ${formatter.format(amount)}';
}

String formatDateIndonesian(DateTime date) {
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
