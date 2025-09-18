import 'package:money_expense/services/database_service.dart';
import 'package:money_expense/services/expense_service.dart';
import 'package:money_expense/ui/bottom_sheets/category/category_sheet.dart';
import 'package:money_expense/ui/views/add_expense/add_expense_view.dart';
import 'package:money_expense/ui/views/home/home_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: AddExpenseView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: ExpenseService),
    LazySingleton(classType: DatabaseService),
    LazySingleton(classType: SnackbarService),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: CategorySheet),
// @stacked-bottom-sheet
  ],
)
class App {}
