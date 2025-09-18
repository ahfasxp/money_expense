import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_expense/ui/common/app_colors.dart';
import 'package:money_expense/ui/common/app_svgs.dart';
import 'package:money_expense/ui/common/app_texts.dart';
import 'package:money_expense/ui/widgets/custom_textfield.dart';
import 'package:stacked/stacked.dart';

import 'add_expense_viewmodel.dart';

class AddExpenseView extends StackedView<AddExpenseViewModel> {
  const AddExpenseView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AddExpenseViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcWhite,
      appBar: AppBar(
        backgroundColor: kcWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(36, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: SvgPicture.asset(AppSvgs.angleLeft),
          onPressed: viewModel.back,
        ),
        title: Text(
          'Tambah Pengeluaran Baru',
          style: ktBigTitle.copyWith(color: kcGray1),
        ),
        iconTheme: const IconThemeData(color: kcGray1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 20),
        child: Column(
          children: [
            CustomTextField(
              controller: viewModel.nameController,
              hintText: 'Nama Pengeluaran',
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: viewModel.categoryController,
              onTap: viewModel.showCategorySheet,
              prefixIcon: SvgPicture.asset(
                viewModel.selectedCategory?.iconPath ?? AppSvgs.food,
                fit: BoxFit.scaleDown,
                colorFilter: ColorFilter.mode(
                  viewModel.selectedCategory?.color ?? kcYellow,
                  BlendMode.srcIn,
                ),
              ),
              hintText: 'Pilih Kategori',
              suffixIcon: IconButton(
                onPressed: null,
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  fixedSize: const Size(24, 24),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  disabledBackgroundColor: kcGray5,
                ),
                icon: Transform.rotate(
                  angle: 3.1416, // π rad = 180 derajat
                  child: SvgPicture.asset(AppSvgs.angleLeft,
                      width: 16, height: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: viewModel.dateController,
              onTap: viewModel.selectDate,
              hintText: 'Tanggal Pengeluaran',
              suffixIcon: SvgPicture.asset(
                AppSvgs.calendar,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomTextField(
              controller: viewModel.amountController,
              hintText: 'Nominal',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 32,
            ),
            ElevatedButton(
              onPressed: viewModel.isFormValid ? viewModel.saveExpense : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kcBlue,
                disabledBackgroundColor: kcGray5,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                'Simpan',
                style: ktBigTitle.copyWith(color: kcWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  AddExpenseViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AddExpenseViewModel();

  @override
  void onViewModelReady(AddExpenseViewModel viewModel) =>
      viewModel.initialise();
}
