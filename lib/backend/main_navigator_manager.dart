import 'package:checkpoint/models/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_command/flutter_command.dart';

class MainNavigatorManager extends ChangeNotifier {
  MainNavigatorManager({this.navItem = NavItem.map}) {
    goToCommand = Command.createSyncNoResult((NavItem item) {
      navItem = item;
      notifyListeners();
    });
  }

  late Command<NavItem, void> goToCommand;

  NavItem navItem;
}
