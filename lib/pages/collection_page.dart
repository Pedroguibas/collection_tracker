import 'package:collection_tracker/components/item_list.dart';
import 'package:collection_tracker/db/DAO.dart';
import 'package:collection_tracker/pages/item_page.dart';
import 'package:collection_tracker/pages/new_collection_page.dart';
import 'package:collection_tracker/pages/new_item_page.dart';
import 'package:collection_tracker/types/collection_type.dart';
import 'package:collection_tracker/types/item_type.dart';
import 'package:flutter/material.dart';

class CollectionPage extends StatefulWidget {
  CollectionType collection;

  CollectionPage({super.key, required this.collection});

  @override
  State<CollectionPage> createState() {
    return _CollectionPageState();
  }
}

class _CollectionPageState extends State<CollectionPage> {
  List<ItemType> _items = [];

  void _updateItems() async {
    var updatedItems = await DAO.getItemsFromCollection(widget.collection.id);
    setState(() {
      _items = updatedItems;
    });
  }

  Future<void> add() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewItemPage(collectionId: widget.collection.id),
      ),
    );
    _updateItems();
    if (newItem != null && newItem is ItemType) {
      _updateItems();
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ItemPage(item: newItem)),
      );
      _updateItems();
    }
  }

  Future<void> deleteCollection() async {
    bool deleted = false;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Delete Collection"),
          content: Text("Are you sure you want to delete this collection?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await DAO.deleteCollection(widget.collection.id);
                deleted = true;
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
    if (deleted) {
      Navigator.pop(context);
    }
  }

  Future<void> openItemPage(ItemType item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ItemPage(item: item)),
    );
    _updateItems();
  }

  Future<void> editCollection() async {
    final updatedCollection = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewCollectionPage(editingCollection: widget.collection),
      ),
    );

    if (updatedCollection is CollectionType) {
      setState(() {
        widget.collection = updatedCollection;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collection Tracker"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: add,
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 16),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.collection.img),
              ),
              SizedBox(height: 16),
              Text(
                widget.collection.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: editCollection,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 4),
                        Text("Edit"),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  FilledButton(
                    onPressed: deleteCollection,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 4),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: ItemList(items: _items, openItemPage: openItemPage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
