import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:monkey/providers/river_level_stream_provider.dart';

final simpleStateMachineProvider =
    StateNotifierProvider<SimpleStateMachineNotifier, SimpleStateMachineState>(
  (ref) => SimpleStateMachineNotifier(),
);

class SimpleStateMachineNotifier
    extends StateNotifier<SimpleStateMachineState> {
  SimpleStateMachineNotifier() : super(SimpleStateMachineState());

  void onRiveInit(Artboard artboard, RiverLevel riverLevel) {
    var controller =
        StateMachineController.fromArtboard(artboard, 'State Machine');

    if (controller != null) {
      artboard.addController(controller);

      state.numberExampleInput = controller.findInput<double>('Level');

      if (state.numberExampleInput != null) {
        state.numberExampleInput!.value = riverLevel.measureInM;
        print(
            'numberExampleInput- ${riverLevel.locationName} - ${riverLevel.measureInM}');
      } else {
        print('Error: Unable to find SMIInput<double> with name "level".');
      }
    } else {
      print('Error: Unable to create StateMachineController from artboard.');
    }
  }
}

class SimpleStateMachineState {
  SMIInput<double>? numberExampleInput;
}

class SimpleStateMachine extends ConsumerWidget {
  const SimpleStateMachine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riverLevelCurrent = ref.watch(riverLevelStreamProvider).when(
          data: (value) {
            print(value.measureInM);
            return value;
          },

          loading: () => RiverLevel(
              locationName: "loading",
              measureInM: 00.0), // Placeholder value during loading
          error: (error, stackTrace) => RiverLevel(
              locationName: "error",
              measureInM: 900.0), // Placeholder value on error
        );
    // print(diverLevel.age);
    print(
        '${riverLevelCurrent.locationName} - ${riverLevelCurrent.measureInM}');

    return RiveAnimation.asset(
      'assets/rive/canal.riv',
      fit: BoxFit.cover,
      onInit: (artboard) {
        ref.read(simpleStateMachineProvider.notifier).onRiveInit(
              artboard,
              riverLevelCurrent,
            );
      },
      animations: const ['Idle'],
      stateMachines: ['State Machine'],
    );
  }
}
