import 'package:flutter/material.dart';
import 'package:money_expense/ui/common/app_colors.dart';
import 'package:money_expense/ui/common/app_texts.dart';
import 'package:money_expense/ui/widgets/expense_card.dart';
import 'package:money_expense/ui/widgets/expense_category_card.dart';
import 'package:money_expense/ui/widgets/expense_tile.dart';
import 'package:shimmer/shimmer.dart';
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
          onRefresh: viewModel.loadData,
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
                      // Expense Cards with shimmer
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ExpenseCard(
                                title: 'Pengeluaranmu hari ini',
                                amount: viewModel.todayTotalFormatted,
                                color: kcBlue,
                                isLoading: viewModel.isLoading,
                              ),
                            ),
                            const SizedBox(width: 19),
                            Expanded(
                              child: ExpenseCard(
                                title: 'Pengeluaranmu bulan ini',
                                amount: viewModel.monthTotalFormatted,
                                color: kcTeal,
                                isLoading: viewModel.isLoading,
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
                // Horizontal ListView for categories with shimmer
                SizedBox(
                  height: 162,
                  child: viewModel.isLoading
                      ? _buildCategoryListShimmer()
                      : viewModel.categoryTotals.isNotEmpty
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
                                  amount:
                                      viewModel.getFormattedAmount(entry.value),
                                );
                              },
                            )
                          : Padding(
                              padding: const EdgeInsets.all(20),
                              child: notFound(),
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
                      // Today's expenses with shimmer
                      viewModel.isLoading
                          ? _buildExpenseListShimmer(3)
                          : viewModel.todayExpenses.isNotEmpty
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: viewModel.todayExpenses.length,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 20),
                                  itemBuilder: (context, index) {
                                    final expense =
                                        viewModel.todayExpenses[index];
                                    return ExpenseTile(
                                      title: expense.name,
                                      category: expense.category,
                                      amount: viewModel
                                          .getFormattedAmount(expense.amount),
                                    );
                                  },
                                )
                              : notFound(),
                      const SizedBox(height: 28),
                      Text(
                        'Kemarin',
                        style: ktParagraphBold.copyWith(color: kcGray1),
                      ),
                      const SizedBox(height: 20),
                      // Yesterday's expenses with shimmer
                      viewModel.isLoading
                          ? _buildExpenseListShimmer(2)
                          : viewModel.yesterdayExpenses.isNotEmpty
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
                              : notFound(),
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
                color: Color(0x0A000000),
                offset: Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 4,
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

  Container notFound() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kcGray5,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Belum ada pengeluaran',
          style: ktParagraphMedium.copyWith(color: kcGray3),
        ),
      ),
    );
  }

  Widget _buildCategoryListShimmer() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      separatorBuilder: (context, index) => const SizedBox(width: 20),
      padding: const EdgeInsets.all(20),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpenseListShimmer(int itemCount) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 80,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.initialise();
}
