class CollectionType {
  final int id;
  final String name;
  final String img;

  CollectionType({required this.id, required this.name, required this.img});

  factory CollectionType.fromMap(Map<String, dynamic> map) {
    return CollectionType(id: map["id"], name: map["name"], img: map["img"]);
  }
}
