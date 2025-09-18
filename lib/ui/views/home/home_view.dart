import 'package:flutter/material.dart';
import 'package:money_expense/ui/common/app_colors.dart';
import 'package:money_expense/ui/common/app_svgs.dart';
import 'package:money_expense/ui/common/app_texts.dart';
import 'package:money_expense/ui/widgets/expense_card.dart';
import 'package:money_expense/ui/widgets/expense_category_card.dart';
import 'package:money_expense/ui/widgets/expense_tile.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: kcWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, User!',
                style: ktBigTitle.copyWith(color: kcGray1),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Jangan lupa catat keuanganmu setiap hari!',
                style: ktParagraphMedium.copyWith(color: kcGray3),
              ),
              const SizedBox(
                height: 20,
              ),
              const IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ExpenseCard(
                        title: 'Pengeluaranmu hari ini',
                        amount: 'Rp. 30.000',
                        color: kcBlue,
                      ),
                    ),
                    SizedBox(width: 19),
                    Expanded(
                      child: ExpenseCard(
                        title: 'Pengeluaranmu bulan ini',
                        amount: 'Rp. 30.000',
                        color: kcTeal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Pengeluaran berdasarkan kategori',
                style: ktParagraphBold.copyWith(color: kcGray1),
              ),
              const SizedBox(
                height: 20,
              ),
              const ExpenseCategoryCard(
                icon: AppSvgs.food,
                iconColor: kcBlue,
                title: 'Makanan',
                amount: 'Rp. 20.000',
              ),
              const SizedBox(
                height: 28,
              ),
              Text(
                'Hari ini',
                style: ktParagraphBold.copyWith(color: kcGray1),
              ),
              const SizedBox(
                height: 20,
              ),
              const ExpenseTile(
                icon: AppSvgs.food,
                iconColor: kcYellow,
                title: 'Ayam Geprek',
                amount: 'Rp. 15.000',
              ),
              const SizedBox(
                height: 28,
              ),
              Text(
                'Kemarin',
                style: ktParagraphBold.copyWith(color: kcGray1),
              ),
              const SizedBox(
                height: 20,
              ),
              const ExpenseTile(
                icon: AppSvgs.internet,
                iconColor: kcBlue,
                title: 'Ojek Online',
                amount: 'Rp. 15.000',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: viewModel.navigateToAddExpenseView,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: kcBlue,
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000), // hitam 3.9% opacity
                offset: Offset(0, 4), // x=0, y=4
                blurRadius: 8, // blur
                spreadRadius: 4, // spread
              ),
            ],
          ),
          child: const Icon(
            Icons.add,
            size: 16,
            color: kcWhite,
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}
