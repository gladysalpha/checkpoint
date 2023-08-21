import 'package:checkpoint/backend/main_navigator_manager.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

import '../models/nav_item.dart';

class AnimatedFabStack extends StatefulWidget {
  const AnimatedFabStack({
    super.key,
  });

  @override
  State<AnimatedFabStack> createState() => _AnimatedFabStackState();
}

class _AnimatedFabStackState extends State<AnimatedFabStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
      reverseDuration: const Duration(
        milliseconds: 200,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: _controller.value * 70,
                  bottom: _controller.value * 70,
                ),
                child: CustomFab(
                  item: NavItem.checkpoints,
                  onTap: (NavItem item) {
                    di<MainNavigatorManager>().goToCommand.execute(item);
                    _controller.reverse();
                  },
                  elevation: _controller.value * 3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: _controller.value * 70,
                ),
                child: CustomFab(
                  item: NavItem.addCheckpoint,
                  onTap: (NavItem item) {
                    di<MainNavigatorManager>().goToCommand.execute(item);
                    _controller.reverse();
                  },
                  elevation: _controller.value * 3,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: _controller.value * 70,
                ),
                child: CustomFab(
                  item: NavItem.map,
                  onTap: (NavItem item) {
                    di<MainNavigatorManager>().goToCommand.execute(item);
                    _controller.reverse();
                  },
                  elevation: _controller.value * 3,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomFab(
                  item: NavItem.none,
                  onTap: (item) {
                    if (_controller.status == AnimationStatus.completed) {
                      _controller.reverse();
                    } else {
                      _controller.forward();
                    }
                  },
                ),
              ),
            ],
          );
        });
  }
}

class CustomFab extends StatelessWidget {
  const CustomFab(
      {super.key, required this.onTap, this.elevation = 4, required this.item});
  final ValueChanged<NavItem> onTap;
  final double? elevation;
  final NavItem item;

  Image getItemsAsset() {
    String assetPath = "assets/images/navMenuIcon.png";
    switch (item) {
      case NavItem.checkpoints:
        assetPath = "assets/images/navListIcon.png";
        break;
      case NavItem.addCheckpoint:
        assetPath = "assets/images/navAddIcon.png";
        break;

      case NavItem.map:
        assetPath = "assets/images/navMapIcon.png";
        break;

      case NavItem.none:
        assetPath = "assets/images/navMenuIcon.png";
        break;
    }

    return Image.asset(assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(
          fixedSize: MaterialStatePropertyAll(
            Size(60.0, 60.0),
          ),
          padding: MaterialStatePropertyAll(
            EdgeInsets.all(
              16.0,
            ),
          ),
          backgroundColor: MaterialStatePropertyAll(
            Color(0xFFFFDCC5),
          ),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
          )),
      onPressed: () => onTap(item),
      child: getItemsAsset(),
    );
  }
}
