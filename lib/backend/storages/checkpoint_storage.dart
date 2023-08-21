import '../../models/checkpoint.dart';

class CheckpointStorage {
  const CheckpointStorage({required this.checkpoints});
  final Set<Checkpoint> checkpoints;

  static const empty = CheckpointStorage(checkpoints: {});

  CheckpointStorage copyWith({
    Set<Checkpoint>? checkpoints,
  }) {
    return CheckpointStorage(
      checkpoints: checkpoints != null
          ? Set.unmodifiable(checkpoints)
          : this.checkpoints,
    );
  }
}
