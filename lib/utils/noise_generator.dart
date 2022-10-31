import 'dart:io';

import 'package:fast_noise/fast_noise.dart';
import 'package:flutter/material.dart';
import 'package:osarona/map/biomes.dart';
import 'package:osarona/map/map.dart';
import 'package:image/image.dart' as img;

List<List<double>> generateNoise(Map<String, dynamic> data) {
  Size size = data['size'] as Size;
  final original = noise2(size.width.toInt(), size.height.toInt(),
      seed: data['seed'],
      frequency: data['frequency'],
      noiseType: data['noiseType'],
      cellularReturnType: CellularReturnType.Distance,
      cellularDistanceFunction: data['cellularDistanceFunction']);

  return original;
}

void saveMap(Size size, List<List<double>> map) {
  final image = img.Image.rgb(size.width.toInt(), size.height.toInt());

  int r = 0, g = 0, b = 0;

  for (var x = 0; x < size.width; x++) {
    for (var y = 0; y < size.height; y++) {
      switch (BiomeType.values[map[x][y].toInt()]) {
        case BiomeType.forest:
          r = 53;
          g = 164;
          b = 64;
          break;
        case BiomeType.beach:
        r = 224;
        g = 248;
        b = 120;
        break;
        case BiomeType.grassLand:
        r = 57;
        g = 190;
        b = 65;
        break;
        case BiomeType.tundra:
          r = 148;
          g = 120;
          b = 91;
          break;
        case BiomeType.ocean:
          r = 30;
          g = 124;
          b = 184;
          break;
      }

      image.setPixelRgba(x, y, r, g, b, 0xff);
    }
  }

  print('saving map...');
  File('./noise.png').writeAsBytesSync(img.encodePng(image));
}
