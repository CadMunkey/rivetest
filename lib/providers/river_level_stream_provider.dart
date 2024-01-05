import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final riverLevelStreamProvider = StreamProvider<RiverLevel>((ref) {
  final streamController = StreamController<RiverLevel>();
  RiverLevel latestRiverLevel = RiverLevel();
  double testIncrement = 1.5;
  Timer.periodic(const Duration(seconds: 1), (timer) {
    latestRiverLevel.measureInM += testIncrement;
    if (latestRiverLevel.measureInM > 90.0) {
      testIncrement = -1.5;
    } else if (latestRiverLevel.measureInM < 10.0) {
      testIncrement = 1.5;
    }
    streamController.add(latestRiverLevel);
  });
  ref.onDispose(() {
    streamController.close();
  });
  return streamController.stream;
});

class RiverLevel {
  double measureInM;
  String locationName;
  RiverLevel({this.locationName = 'somehere', this.measureInM = 10});
}
