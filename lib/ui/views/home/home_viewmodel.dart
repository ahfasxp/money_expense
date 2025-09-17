import 'package:money_expense/app/app.locator.dart';
import 'package:money_expense/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  void navigateToAddExpenseView() {
    _navigationService.navigateToAddExpenseView();
  }
}
