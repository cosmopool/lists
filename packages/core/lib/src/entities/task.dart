import "dart:typed_data";

import "package:core/src/entities/node.dart";

sealed class Entity {
  Entity({required this.id, this.parentId});

  final ID id;
  final ID? parentId;
}

class Task extends Entity {
  Task({
    required super.id,
    required this.title,
    required this.completed,
    super.parentId,
  });

  String title;
  bool completed;
}

class WebLink extends Entity {
  WebLink({required super.id, required this.url, super.parentId});

  String url;
}

class Image extends Entity {
  Image({
    required super.id,
    required this.title,
    required this.binary,
    super.parentId,
  });

  String title;
  Uint8List binary;
}

class Audio extends Entity {
  Audio({
    required super.id,
    required this.path,
    required this.lenght,
    super.parentId,
  });

  String path;
  final int lenght;
}
