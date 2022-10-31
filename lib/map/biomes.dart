import 'package:bonfire/bonfire.dart';

enum BiomeType { grassLand, forest, tundra, beach, ocean }

const tileSpriteSheetPath = 'tiles/Overworld.png';

abstract class Biome {
  final BiomeType type;
  final double minHeight;
  final double minMoisture;
  final double minHeat;
  final List<MapTerrain> tiles;

  static final Vector2 tileSize = Vector2.all(16);

  Biome(
      {required this.type,
      required this.minHeight,
      required this.minMoisture,
      required this.minHeat,
      required this.tiles});

  static BiomeType getBiome(double height, double moisture, double heat) {
    List<Biome> possibleBiomes = [];

    for (BiomeType type in BiomeType.values) {
      Biome biome = Biome.byBiomeType(type);

      if (biome.matchConditions(height, moisture, heat)) {
        possibleBiomes.add(biome);
      }
    }

    if(possibleBiomes.isEmpty) {
      return BiomeType.ocean;
    }
    Biome biomeToReturn = possibleBiomes.first;
    double curVal = biomeToReturn.getDiffValue(height, moisture, heat);

    for(Biome possible in possibleBiomes) {
      if(possible.getDiffValue(height, moisture, heat) < curVal) {
        biomeToReturn = possible;
        curVal = biomeToReturn.getDiffValue(height, moisture, heat);
      }
    }
    return biomeToReturn.type;
  }

  double getDiffValue(double height, double moisture, double heat) {
    // return (height - minHeight) + (moisture - minMoisture) + (heat - minHeat);
    return (height - minHeight);
  }

  bool matchConditions(double height, double moisture, double heat) =>
      height >= minHeight;

  factory Biome.byBiomeType(BiomeType type) {
    switch (type) {
      case BiomeType.grassLand:
        return GrassLand();
      case BiomeType.forest:
        return Forest();
      case BiomeType.tundra:
        return Tundra();
      case BiomeType.beach:
        return Beach();
      case BiomeType.ocean:
      default:
        return Ocean();
    }
  }
}

class GrassLand extends Biome {
  static final List<MapTerrain> mapTerrains = [
    MapTerrain(value: BiomeType.grassLand.index.toDouble(), sprites: [
      TileModelSprite(
          path: tileSpriteSheetPath,
          size: Biome.tileSize,
          position: Vector2(0, 0))
    ]),
    MapTerrainCorners(
        value: BiomeType.grassLand.index.toDouble(),
        to: BiomeType.ocean.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/grass_to_water.png', tileSize: Biome.tileSize)),
    MapTerrainCorners(
        value: BiomeType.grassLand.index.toDouble(),
        to: BiomeType.beach.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/grass_to_sand.png', tileSize: Biome.tileSize)),
    MapTerrainCorners(
        value: BiomeType.grassLand.index.toDouble(),
        to: BiomeType.forest.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/grass_to_forest.png', tileSize: Biome.tileSize)),
    MapTerrainCorners(
        value: BiomeType.grassLand.index.toDouble(),
        to: BiomeType.tundra.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/grass_to_dirt.png', tileSize: Biome.tileSize)),
  ];

  static final GrassLand _singleton = GrassLand._internal();

  factory GrassLand() => _singleton;

  GrassLand._internal()
      : super(
            type: BiomeType.grassLand,
            minHeight: 0,
            minMoisture: 0.5,
            minHeat: 0.3,
            tiles: mapTerrains);
}

class Forest extends Biome {
  static final List<MapTerrain> mapTerrains = [
    MapTerrain(value: BiomeType.forest.index.toDouble(), sprites: [
      TileModelSprite(
          path: tileSpriteSheetPath,
          size: Biome.tileSize,
          position: Vector2(17, 29))
    ]),
    MapTerrainCorners(
        value: BiomeType.forest.index.toDouble(),
        to: BiomeType.grassLand.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/forest_to_grass.png', tileSize: Biome.tileSize)),
  ];

  static final Forest _singleton = Forest._internal();

  factory Forest() => _singleton;

  Forest._internal()
      : super(
            type: BiomeType.forest,
            minHeight: 0.2,
            minMoisture: 0.4,
            minHeat: 0.4,
            tiles: mapTerrains);
}

class Tundra extends Biome {
  static final List<MapTerrain> mapTerrains = [
    MapTerrain(value: BiomeType.tundra.index.toDouble(), sprites: [
      TileModelSprite(
          path: tileSpriteSheetPath,
          size: Biome.tileSize,
          position: Vector2(2, 32))
    ]),
    MapTerrainCorners(
        value: BiomeType.tundra.index.toDouble(),
        to: BiomeType.grassLand.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/dirt_to_grass.png', tileSize: Biome.tileSize)),
  ];

  static final Tundra _singleton = Tundra._internal();

  factory Tundra() => _singleton;

  Tundra._internal()
      : super(
            type: BiomeType.tundra,
            minHeight: 0,
            minMoisture: -0.5,
            minHeat: 0.5,
            tiles: mapTerrains);
}

class Ocean extends Biome {
  static final List<MapTerrain> mapTerrains = [
    MapTerrain(
        value: BiomeType.ocean.index.toDouble(),
        collisionOnlyCloseCorners: true,
        collisions: [
          CollisionArea.rectangle(size: Biome.tileSize)
        ],
        sprites: [
          TileModelSprite(
              path: tileSpriteSheetPath,
              size: Biome.tileSize,
              position: Vector2(0, 1)),
          TileModelSprite(
              path: tileSpriteSheetPath,
              size: Biome.tileSize,
              position: Vector2(1, 1)),
          TileModelSprite(
              path: tileSpriteSheetPath,
              size: Biome.tileSize,
              position: Vector2(2, 1)),
          TileModelSprite(
              path: tileSpriteSheetPath,
              size: Biome.tileSize,
              position: Vector2(3, 1)),
          TileModelSprite(
              path: tileSpriteSheetPath,
              size: Biome.tileSize,
              position: Vector2(0, 2)),
          TileModelSprite(
              path: tileSpriteSheetPath,
              size: Biome.tileSize,
              position: Vector2(1, 2)),
          TileModelSprite(
              path: tileSpriteSheetPath,
              size: Biome.tileSize,
              position: Vector2(2, 2)),
          TileModelSprite(
              path: tileSpriteSheetPath,
              size: Biome.tileSize,
              position: Vector2(3, 2))
        ]),
    MapTerrainCorners(
        value: BiomeType.ocean.index.toDouble(),
        to: BiomeType.grassLand.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/water_to_grass.png', tileSize: Biome.tileSize)),
    MapTerrainCorners(
        value: BiomeType.ocean.index.toDouble(),
        to: BiomeType.beach.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/water_to_sand.png', tileSize: Biome.tileSize))
  ];

  static final Ocean _singleton = Ocean._internal();

  factory Ocean() => _singleton;

  Ocean._internal()
      : super(
            type: BiomeType.ocean,
            minHeight: -1,
            minMoisture: 0,
            minHeat: -1,
            tiles: mapTerrains);
}

class Beach extends Biome {
  static final List<MapTerrain> mapTerrains = [
    MapTerrain(value: BiomeType.beach.index.toDouble(), sprites: [
      TileModelSprite(
          path: tileSpriteSheetPath,
          size: Biome.tileSize,
          position: Vector2(4, 1))
    ]),
    MapTerrainCorners(
        value: BiomeType.beach.index.toDouble(),
        to: BiomeType.grassLand.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/sand_to_grass.png', tileSize: Biome.tileSize)),
    MapTerrainCorners(
        value: BiomeType.beach.index.toDouble(),
        to: BiomeType.ocean.index.toDouble(),
        spriteSheet: TerrainSpriteSheet.create(
            path: 'tiles/sand_to_water.png', tileSize: Biome.tileSize))
  ];

  static final Beach _singleton = Beach._internal();

  factory Beach() => _singleton;

  Beach._internal()
      : super(
            type: BiomeType.beach,
            minHeight: -0.1,
            minMoisture: 0.1,
            minHeat: 0.2,
            tiles: mapTerrains);
}
