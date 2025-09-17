import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_expense/ui/common/app_colors.dart';
import 'package:money_expense/ui/common/app_texts.dart';

class ExpenseCategoryCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final String amount;

  const ExpenseCategoryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: kcWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08), // rgba(0,0,0,0.08)
            offset: const Offset(0, 4), // x=0px, y=4px
            blurRadius: 8, // blur: 8px
            spreadRadius: 4, // spread: 4px
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: iconColor,
            ),
            child: Center(
              child: SvgPicture.asset(
                icon,
                width: 20,
                height: 20,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: ktCaptionMedium.copyWith(color: kcGray3),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: ktCaptionBold.copyWith(color: kcGray1),
          )
        ],
      ),
    );
  }
}
