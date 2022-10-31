import 'package:bonfire/bonfire.dart';
import 'package:osarona/components/player.dart' as game;

class RealmMap {
  static double tileSize = 45;
  final GameMap map;
  final game.Player player;
  final List<GameComponent> components;

  RealmMap(this.map, this.player, this.components);
}
