import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:money_expense/enums/category_enum.dart';
import 'package:money_expense/ui/common/app_colors.dart';
import 'package:money_expense/ui/common/app_texts.dart';

class ExpenseTile extends StatelessWidget {
  final String title;
  final String category;
  final String amount;

  const ExpenseTile({
    super.key,
    required this.title,
    required this.category,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final categoryEnum = CategoryEnum.fromString(category);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 22,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: kcWhite,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000), // shadow hitam 8% opacity
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 4,
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            categoryEnum?.iconPath ?? CategoryEnum.food.iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              categoryEnum?.color ?? CategoryEnum.food.color,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              title,
              style: ktParagraphMedium.copyWith(color: kcGray1),
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            amount,
            style: ktParagraphSemiBold.copyWith(color: kcGray1),
          ),
        ],
      ),
    );
  }
}
