import 'package:flutter/material.dart';
import 'package:money_expense/ui/common/app_colors.dart';
import 'package:money_expense/ui/common/app_texts.dart';

class ExpenseCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const ExpenseCard({
    super.key,
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: ktParagraphSemiBold.copyWith(color: kcWhite),
          ),
          const SizedBox(height: 14),
          Text(
            amount,
            style: ktBigTitle.copyWith(color: kcWhite),
          )
        ],
      ),
    );
  }
}
