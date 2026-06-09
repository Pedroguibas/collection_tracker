import 'package:collection_tracker/types/collection_type.dart';
import 'package:collection_tracker/types/item_type.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DAO {
  static Future<void> createTables(sql.Database db) async {
    await db.execute("""
      CREATE TABLE collections (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        img TEXT NOT NULL
      );
    """);
    await db.execute("""
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        img TEXT NOT NULL,
        description TEXT,
        collection INTEGER NOT NULL,

        FOREIGN KEY (collection)
          REFERENCES collections(id)
          ON DELETE CASCADE
      );
    """);

    await db.execute("""
      INSERT INTO collections (name, img) VALUES ('Pokémon TCG', 'https://images.seeklogo.com/logo-png/51/1/pokemon-trading-card-game-logo-png_seeklogo-510687.png');
    """);

    await db.execute("""
      INSERT INTO items (name, description, collection, img) VALUES ('Charizard ex - 199/165 - SV: Scarlet & Violet 151', 'TCG Charizard card from Scarlet & Violet 151 PSA 10', 1, 'https://tcgplayer-cdn.tcgplayer.com/product/517045_in_1000x1000.jpg');
    """);

    await db.execute("""
      INSERT INTO items (name, description, collection, img) VALUES ('Umbreon VMAX | Evolving Skies', 'TCG Umbreon card from Evolving Skies PSA 10', 1, 'https://assets.pokemon.com/static-assets/content-assets/cms2/img/cards/web/SWSH7/SWSH7_EN_215.png');
    """);
  }

  static Future<sql.Database> getDb() async {
    return sql.openDatabase(
      "collection_tracker.db",
      version: 1,
      onCreate: (db, version) async {
        await createTables(db);
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  static Future<int> insertCollection(CollectionType collection) async {
    final db = await DAO.getDb();
    final values = {"name": collection.name, "img": collection.img};
    final id = await db.insert("collections", values);

    return id;
  }

  static Future<int> insertItem(ItemType item) async {
    final db = await DAO.getDb();
    final values = {
      "name": item.name,
      "img": item.img,
      "description": item.description,
      "collection": item.collection,
    };
    final id = await db.insert("items", values);

    return id;
  }

  static Future<List<CollectionType>> getAllCollections() async {
    final db = await DAO.getDb();
    final maps = await db.query("collections", orderBy: "name");

    return maps.map((m) => CollectionType.fromMap(m)).toList();
  }

  static Future<List<ItemType>> getItemsFromCollection(int collectionId) async {
    final db = await DAO.getDb();
    final maps = await db.query(
      "items",
      orderBy: "name",
      where: "collection = ?",
      whereArgs: [collectionId],
    );

    return maps.map((m) => ItemType.fromMap(m)).toList();
  }

  static Future<bool> deleteCollection(int id) async {
    final db = await DAO.getDb();
    final rows = await db.delete(
      "collections",
      where: "id = ?",
      whereArgs: [id],
    );

    return rows > 0;
  }

  static Future<bool> deleteItem(int id) async {
    final db = await DAO.getDb();
    final rows = await db.delete("items", where: "id = ?", whereArgs: [id]);

    return rows > 0;
  }

  static Future<int> updateCollection(CollectionType collection) async {
    final db = await DAO.getDb();
    final values = {
      "id": collection.id,
      "name": collection.name,
      "img": collection.img,
    };
    final rows = await db.update(
      "collections",
      values,
      where: "id = ?",
      whereArgs: [collection.id],
    );

    return rows;
  }

  static Future<int> updateItem(ItemType item) async {
    final db = await DAO.getDb();
    final values = {
      "id": item.id,
      "name": item.name,
      "img": item.img,
      "description": item.description,
      "collection": item.collection,
    };

    final rows = await db.update(
      "items",
      values,
      where: "id = ?",
      whereArgs: [item.id],
    );

    return rows;
  }
}
