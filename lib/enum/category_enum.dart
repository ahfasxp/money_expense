import 'package:flutter/material.dart';
import 'package:money_expense/ui/common/app_colors.dart';

enum CategoryEnum {
  food("Makanan", "assets/svgs/pizza.svg", kcYellow),
  internet("Internet", "assets/svgs/rss.svg", kcBlue3),
  education("Edukasi", "assets/svgs/book.svg", kcOrange),
  gift("Hadiah", "assets/svgs/gift.svg", kcRed),
  transport("Transportasi", "assets/svgs/car.svg", kcPurple1),
  shopping("Belanja", "assets/svgs/shopping-cart.svg", kcGreen2),
  home("Alat Rumah", "assets/svgs/home.svg", kcPurple2),
  sports("Olahraga", "assets/svgs/basketball.svg", kcBlue2),
  entertainment("Hiburan", "assets/svgs/clapper-board.svg", kcBlue1);

  final String label;
  final String iconPath;
  final Color color;

  const CategoryEnum(this.label, this.iconPath, this.color);

  static CategoryEnum? fromString(String value) {
    switch (value.toLowerCase()) {
      case 'makanan':
        return CategoryEnum.food;
      case 'internet':
        return CategoryEnum.internet;
      case 'edukasi':
        return CategoryEnum.education;
      case 'hadiah':
        return CategoryEnum.gift;
      case 'transportasi':
        return CategoryEnum.transport;
      case 'belanja':
        return CategoryEnum.shopping;
      case 'alat rumah':
        return CategoryEnum.home;
      case 'olahraga':
        return CategoryEnum.sports;
      case 'hiburan':
        return CategoryEnum.entertainment;
      default:
        return null;
    }
  }
}
