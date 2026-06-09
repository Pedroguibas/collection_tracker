import 'package:collection_tracker/db/DAO.dart';
import 'package:collection_tracker/pages/new_item_page.dart';
import 'package:collection_tracker/types/item_type.dart';
import 'package:flutter/material.dart';

class ItemPage extends StatefulWidget {
  ItemType item;

  ItemPage({super.key, required this.item});

  @override
  State<StatefulWidget> createState() {
    return _ItemPageState();
  }
}

class _ItemPageState extends State<ItemPage> {
  Future<void> edit() async {
    final updatedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewItemPage(
          collectionId: widget.item.collection,
          editingItem: widget.item,
        ),
      ),
    );

    if (updatedItem != null) {
      setState(() {
        widget.item = updatedItem;
      });
    }
  }

  Future<void> delete() async {
    bool deleted = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Item"),
        content: Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await DAO.deleteItem(widget.item.id);
              deleted = true;
              Navigator.pop(context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
    if (deleted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.network(
                            widget.item.img,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.error),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.item.name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.item.description.isNotEmpty) ...[
                          SizedBox(height: 4),
                          Divider(),
                          SizedBox(height: 8),
                          Text(widget.item.description),
                        ],
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                FilledButton(
                  onPressed: edit,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 10),
                        Text("Edit", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 4),
                FilledButton(
                  onPressed: delete,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 10),
                        Text("Delete", style: TextStyle(fontSize: 20)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
