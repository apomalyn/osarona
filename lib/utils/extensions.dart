import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';

extension SizeExtensions on Size {
  Vector2 toVector2() => Vector2(width, height);
}
