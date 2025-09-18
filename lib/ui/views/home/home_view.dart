import 'package:flutter/material.dart';
import 'package:money_expense/ui/common/app_colors.dart';
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
        child: RefreshIndicator(
          onRefresh: viewModel.refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20).copyWith(bottom: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, User!',
                        style: ktBigTitle.copyWith(color: kcGray1),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jangan lupa catat keuanganmu setiap hari!',
                        style: ktParagraphMedium.copyWith(color: kcGray3),
                      ),
                      const SizedBox(height: 20),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ExpenseCard(
                                title: 'Pengeluaranmu hari ini',
                                amount: viewModel.todayTotalFormatted,
                                color: kcBlue,
                              ),
                            ),
                            const SizedBox(width: 19),
                            Expanded(
                              child: ExpenseCard(
                                title: 'Pengeluaranmu bulan ini',
                                amount: viewModel.monthTotalFormatted,
                                color: kcTeal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Pengeluaran berdasarkan kategori',
                        style: ktParagraphBold.copyWith(color: kcGray1),
                      ),
                    ],
                  ),
                ),
                // Horizontal ListView for categories
                SizedBox(
                  height: 162, // Adjust based on ExpenseCategoryCard height
                  child: viewModel.categoryTotals.isNotEmpty
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: viewModel.categoryTotals.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 20),
                          padding: const EdgeInsets.all(20),
                          itemBuilder: (context, index) {
                            final entry = viewModel.categoryTotals.entries
                                .elementAt(index);
                            return ExpenseCategoryCard(
                              title: entry.key,
                              amount: viewModel.getFormattedAmount(entry.value),
                            );
                          },
                        )
                      : const ExpenseCategoryCard(
                          title: 'Belum ada pengeluaran',
                          amount: 'Rp. 0',
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20).copyWith(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hari ini',
                        style: ktParagraphBold.copyWith(color: kcGray1),
                      ),
                      const SizedBox(height: 20),
                      // ListView for today's expenses
                      viewModel.todayExpenses.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.todayExpenses.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemBuilder: (context, index) {
                                final expense = viewModel.todayExpenses[index];
                                return ExpenseTile(
                                  title: expense.name,
                                  category: expense.category,
                                  amount: viewModel
                                      .getFormattedAmount(expense.amount),
                                );
                              },
                            )
                          : Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: kcGray5,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Belum ada pengeluaran',
                                  style: ktParagraphMedium.copyWith(
                                      color: kcGray3),
                                ),
                              ),
                            ),
                      const SizedBox(height: 28),
                      Text(
                        'Kemarin',
                        style: ktParagraphBold.copyWith(color: kcGray1),
                      ),
                      const SizedBox(height: 20),
                      // ListView for yesterday's expenses (max 3 items)
                      viewModel.yesterdayExpenses.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: viewModel.yesterdayExpenses.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 20),
                              itemBuilder: (context, index) {
                                final expense =
                                    viewModel.yesterdayExpenses[index];
                                return ExpenseTile(
                                  title: expense.name,
                                  category: expense.category,
                                  amount: viewModel
                                      .getFormattedAmount(expense.amount),
                                );
                              },
                            )
                          : Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: kcGray5,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Belum ada pengeluaran',
                                  style: ktParagraphMedium.copyWith(
                                      color: kcGray3),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
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

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.initialise();
}
