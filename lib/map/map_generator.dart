import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:osarona/map/map.dart';
import 'package:osarona/utils/noise_generator.dart';
import 'package:osarona/map/biomes.dart';
import 'package:osarona/components/player.dart' as game;

const seedUpLimit = 200000;

class MapGenerator {
  final Size size;

  final Logger _logger = Logger();

  final TerrainBuilder _buildTerrainBuilder =
      TerrainBuilder(tileSize: Biome.tileSize.x, terrainList: [
    ...GrassLand.mapTerrains,
    ...Forest.mapTerrains,
    ...Beach.mapTerrains,
    ...Ocean.mapTerrains,
    ...Tundra.mapTerrains
  ]);

  MapGenerator({required this.size});

  Future<RealmMap> buildMap({int? seed}) async {
    final heightMap = await compute(generateNoise, {
      'size': size,
      'seed': seed ?? Random().nextInt(seedUpLimit),
      'frequency': 0.05,
      'noiseType': NoiseType.PerlinFractal,
      'cellularDistanceFunction': CellularDistanceFunction.Natural,
    });
    _logger.i('Map generation - height map generated');
    final moistureMap = await compute(generateNoise, {
      'size': size,
      'seed': seed ?? Random().nextInt(seedUpLimit),
      'frequency': 0.03,
      'noiseType': NoiseType.PerlinFractal,
      'cellularDistanceFunction': CellularDistanceFunction.Natural,
    });
    _logger.i('Map generation - moisture map generated');
    final heatMap = await compute(generateNoise, {
      'size': size,
      'seed': seed ?? Random().nextInt(seedUpLimit),
      'frequency': 0.04,
      'noiseType': NoiseType.PerlinFractal,
      'cellularDistanceFunction': CellularDistanceFunction.Natural,
    });
    _logger.i('Map generation - heat map generated');

    final List<List<double>> matrix =
        List.filled(size.width.toInt(), List.filled(size.height.toInt(), 0));

    for (int x = 0; x < size.width.toInt(); x++) {
      for (int y = 0; y < size.height.toInt(); y++) {
        matrix[x][y] =
            Biome.getBiome(heightMap[x][y], moistureMap[x][y], heatMap[x][y]).index.toDouble();
      }
    }

    _logger.i('Map generation - map built generating matrix map.');
    saveMap(size, matrix);

    return RealmMap(
        MatrixMapGenerator.generate(
            matrix: matrix, builder: _buildTerrainBuilder.build),
        game.Player(position: Vector2.zero()),
        []);
  }
}
