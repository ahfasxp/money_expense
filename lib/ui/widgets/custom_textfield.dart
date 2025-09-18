import 'package:flutter/material.dart';
import 'package:money_expense/ui/common/app_colors.dart';
import 'package:money_expense/ui/common/app_texts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.keyboardType,
  });

  final InputBorder border = const OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(6),
    ),
    borderSide: BorderSide(
      color: kcGray5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      readOnly: onTap != null,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 14,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: border,
        errorBorder: border,
        focusedErrorBorder: border,
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(
                    child: prefixIcon,
                  ),
                ),
              ),
        hintText: hintText,
        hintStyle: ktParagraphMedium.copyWith(color: kcGray3),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 14),
                child: suffixIcon,
              ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 24,
          minHeight: 24,
        ),
      ),
    );
  }
}
