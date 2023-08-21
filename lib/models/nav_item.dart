import 'package:checkpoint/features/checkpoints/add_checkpoint_form.dart';
import 'package:checkpoint/features/checkpoints/checkpoints_screen.dart';
import 'package:checkpoint/features/map/map_screen.dart';
import 'package:flutter/material.dart';

enum NavItem {
  addCheckpoint("", AddCheckpointScreen.new),
  checkpoints("", CheckpointsScreen.new),
  map("", MapScreen.new),
  none("", SizedBox.new);

  const NavItem(this.navIconAsset, this.builder);

  final String navIconAsset;
  final Widget Function() builder;
}
