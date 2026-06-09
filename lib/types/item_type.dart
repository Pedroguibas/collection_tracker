class ItemType {
  final int id;
  final String name;
  final String img;
  final String description;
  final int collection;

  ItemType({
    required this.id,
    required this.name,
    required this.img,
    required this.description,
    required this.collection,
  });

  factory ItemType.fromMap(Map<String, dynamic> map) {
    return ItemType(
      id: map["id"],
      name: map["name"],
      img: map["img"],
      description: map["description"],
      collection: map["collection"],
    );
  }
}
