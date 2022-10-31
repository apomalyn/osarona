import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:osarona/map/map.dart';
import 'package:osarona/map/map_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  runApp(const MaterialApp(home: Game()));
}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  static const Size _mapSize = Size(150, 150);

  Future<RealmMap>? _generationFuture;

  MapGenerator? _mapGenerator;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        RealmMap.tileSize = max(constraints.maxHeight, constraints.maxWidth) /
            (kIsWeb ? 25 : 22);

        _mapGenerator ??= MapGenerator(size: _mapSize);
        _generationFuture ??= _mapGenerator!.buildMap();

        return FutureBuilder<RealmMap>(
          future: _generationFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Material(
                color: Colors.black,
                child: Center(
                  child: Text(
                    'Generation world...',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
            RealmMap result = snapshot.data!;
            return BonfireWidget(
              joystick: Joystick(
                keyboardConfig: KeyboardConfig(),
                directional: JoystickDirectional(
                  size: 100,
                  isFixed: false,
                ),
              ),
              player: result.player,
              cameraConfig: CameraConfig(
                moveOnlyMapArea: true,
              ),
              map: result.map,
              components: result.components,
              delayToHideProgress: const Duration(milliseconds: 500),
            );
          },
        );
      },
    );
  }
}
