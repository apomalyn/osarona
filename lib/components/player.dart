import 'package:bonfire/bonfire.dart';
import 'package:flutter/material.dart';
import 'package:osarona/map/map.dart';
import 'package:osarona/utils/extensions.dart';

class Player extends SimplePlayer with ObjectCollision {
  Player({
    required Vector2 position
  }) : super(
    position: position,
    size: Vector2(RealmMap.tileSize, RealmMap.tileSize),
    animation: _animation,
  ) {
    enabledDiagonalMovements = false;
    setupCollision(
      CollisionConfig(
        collisions: [
          CollisionArea.rectangle(
            size: Vector2(size.x / 3, size.y / 3),
            align: Vector2(size.x * 1 / 3, size.y * 2 / 3),
          ),
        ],
      ),
    );
  }

  static const _playerSpriteSheetPath = 'characters/character.png';
  static const _playerSpriteSize = Size(16, 32);
  static final _animation = SimpleDirectionAnimation(
    runDown: SpriteAnimation.load(
        _playerSpriteSheetPath, SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: _playerSpriteSize.toVector2(),
      texturePosition: Vector2(0, 0),
    )),
    idleDown: SpriteAnimation.load(_playerSpriteSheetPath,
        SpriteAnimationData.sequenced(amount: 1,
            stepTime: double.maxFinite,
            textureSize: _playerSpriteSize.toVector2(),
            texturePosition: Vector2(2 * _playerSpriteSize.width, 0))),
    runRight: SpriteAnimation.load(
          _playerSpriteSheetPath, SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: 0.1,
        textureSize: _playerSpriteSize.toVector2(),
        texturePosition: Vector2(0, 1 * _playerSpriteSize.height),
      )),
      idleRight: SpriteAnimation.load(_playerSpriteSheetPath,
          SpriteAnimationData.sequenced(amount: 1,
              stepTime: double.maxFinite,
              textureSize: _playerSpriteSize.toVector2(),
              texturePosition: Vector2(2 * _playerSpriteSize.width, 1 * _playerSpriteSize.height))),
    runUp: SpriteAnimation.load(
        _playerSpriteSheetPath, SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: _playerSpriteSize.toVector2(),
      texturePosition: Vector2(0, 2 * _playerSpriteSize.height),
    )),
    idleUp: SpriteAnimation.load(_playerSpriteSheetPath,
        SpriteAnimationData.sequenced(amount: 1,
            stepTime: double.maxFinite,
            textureSize: _playerSpriteSize.toVector2(),
            texturePosition: Vector2(2 * _playerSpriteSize.width, 2 * _playerSpriteSize.height))),
    runLeft: SpriteAnimation.load(
        _playerSpriteSheetPath, SpriteAnimationData.sequenced(
      amount: 4,
      stepTime: 0.1,
      textureSize: _playerSpriteSize.toVector2(),
      texturePosition: Vector2(0, 3 * _playerSpriteSize.height),
    )),
    idleLeft: SpriteAnimation.load(_playerSpriteSheetPath,
        SpriteAnimationData.sequenced(amount: 1,
            stepTime: double.maxFinite,
            textureSize: _playerSpriteSize.toVector2(),
            texturePosition: Vector2(2 * _playerSpriteSize.width, 3 * _playerSpriteSize.height))),
  );
}

