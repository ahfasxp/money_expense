import 'package:money_expense/app/app.locator.dart';
import 'package:money_expense/enums/category_enum.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CategorySheetModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  final categories = CategoryEnum.values;

  void back() {
    _navigationService.back();
  }

  void selectCategory(CategoryEnum category) {
    _navigationService.back(
        result: SheetResponse(
      confirmed: true,
      data: category,
    ));
  }
}
