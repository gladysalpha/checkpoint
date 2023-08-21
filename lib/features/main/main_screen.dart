import 'package:checkpoint/backend/main_navigator_manager.dart';
import 'package:checkpoint/widgets/animated_fab_stack.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../../models/nav_item.dart';

class MainScreen extends StatelessWidget with WatchItMixin {
  MainScreen({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final int index = watch(di<MainNavigatorManager>()).navItem.index;
    return Scaffold(
      floatingActionButton: const AnimatedFabStack(),
      body: IndexedStack(
        index: index,
        children: [
          for (final item in NavItem.values) //
            item.builder(),
        ],
      ),
    );
  }
}
