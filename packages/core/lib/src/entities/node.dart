import "dart:collection";

import "package:core/core.dart";

typedef ID = String;

/// Only used when creating the [RelationshipTree]
///
/// [IdentifierNode] only contains the id of the parent and children.
class IdentifierNode {
  IdentifierNode({required this.id, required this.children, this.parent});

  final ID id;
  IdentifierNode? parent;
  final List<IdentifierNode> children;
}

/// Represents an [Entity] in the [EntityTree]
class EntityNode {
  EntityNode({
    required this.root,
    required this.level,
    required this.children,
    required this.entity,
    this.parent,
  });

  final EntityNode? root;
  final EntityNode? parent;
  bool get isRoot => root == null && parent == null;
  final List<EntityNode> children;
  final Entity entity;
  final int level;
}

// List<IdentifierNode> buildRelationshipTree(List<Entity> flatEntities) {
//   // Map to store lists of child IDs for each parent ID
//   // Key: parentId (or null for root children)
//   // Value: List of child IDs
//   final Map<ID?, List<ID>> parentToChildrenIds = {};
//
//   // Map to store IdentifierNode instances by their ID for quick lookup
//   final Map<ID, IdentifierNode> idToIdentifierNode = {};
//
//   final List<IdentifierNode> rootNodes = [];
//
//   for (Entity entity in flatEntities) {
//     if (entity.parentId != null) {
//       parentToChildrenIds.putIfAbsent(entity.parentId, () => []).add(entity.id);
//     } else {
//       parentToChildrenIds.putIfAbsent(entity.id, () => []);
//     }
//
//     final entityNode =
//
//     final identifierNode = IdentifierNode(
//       id: entity.id,
//       parent: entity.parent,
//       children: [], // Temporarily empty
//     );
//     idToIdentifierNode[entity.id] = identifierNode;
//   }
//
//   for (final MapEntry<ID, IdentifierNode> entry in idToIdentifierNode.entries) {
//     final ID currentId = entry.key;
//     final IdentifierNode currentNode = entry.value;
//
//     final List<ID>? childrenIds = parentToChildrenIds[currentId];
//     assert(
//       childrenIds != null || currentNode.parent == null,
//       "must be children or root node",
//     );
//
//     if (childrenIds != null) {
//       currentNode.children.addAll(childrenIds);
//       continue;
//     }
//
//     if (currentNode.parent == null) rootNodes.add(currentNode);
//   }
//
//   return rootNodes;
// }

/// Constructs a tree of IdentifierNode objects from a flat list of Entities.
/// Returns a list of root nodes (nodes with no parents).
List<IdentifierNode> buildRelationshipTree(List<Entity> entities) {
  // A map to quickly look up IdentifierNodes by their ID.
  // This is crucial for efficient linking of parents and children.
  final Map<ID, IdentifierNode> idToNodeMap = {};

  // 1. First Pass: Create all IdentifierNodes and populate the map.
  // At this stage, nodes only have their 'id' set and empty 'children' lists.
  // 'parent' will be null initially.
  for (final Entity entity in entities) {
    idToNodeMap[entity.id] = IdentifierNode(
      id: entity.id,
      children: [],
      parent: null, // Will be set in the second pass if a parent exists
    );
  }

  // List to hold the root nodes of the tree(s).
  final List<IdentifierNode> rootNodes = [];

  // 2. Second Pass: Establish parent-child relationships.
  for (final Entity entity in entities) {
    final IdentifierNode currentNode = idToNodeMap[entity.id]!;

    // is a root node
    if (entity.parentId == null) {
      rootNodes.add(currentNode);
      continue;
    }

    // is child node so find the parent in the map.
    final IdentifierNode? parentNode = idToNodeMap[entity.parentId];
    assert(
      parentNode != null,
      "Entity with ID ${entity.id} has parentId ${entity.parentId}"
      "but parent entity was not found.",
    );

    if (parentNode != null) {
      // Add the current node to its parent's children list.
      parentNode.children.add(currentNode);
      // Set the parent reference for the current node.
      currentNode.parent = parentNode;
      continue;
    }
  }

  return rootNodes;
}

void levelOrderTraversal(IdentifierNode root) {
  final queue = Queue<IdentifierNode>();
  queue.add(root);

  while (queue.isNotEmpty) {
    // Get the front node
    final IdentifierNode currentNode = queue.removeFirst();

    // Enqueue all children of the current node
    for (IdentifierNode child in currentNode.children) {
      queue.add(child);
    }
  }
}

EntityNode buildEntityTreeFor(IdentifierNode identifierNode) {
  final flatenIds = <String>[];

  while (true) {}
}
