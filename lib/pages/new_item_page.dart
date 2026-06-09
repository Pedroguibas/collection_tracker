import 'package:collection_tracker/common/validator.dart';
import 'package:collection_tracker/db/DAO.dart';
import 'package:collection_tracker/types/item_type.dart';
import 'package:flutter/material.dart';

class NewItemPage extends StatefulWidget {
  ItemType? editingItem;
  final int collectionId;

  NewItemPage({super.key, this.editingItem, required this.collectionId});

  @override
  State<StatefulWidget> createState() {
    return _NewItemPageState();
  }
}

class _NewItemPageState extends State<NewItemPage> {
  var _nameController = TextEditingController();
  var _imgController = TextEditingController();
  var _descriptionController = TextEditingController();

  String appBarText = "New Item";
  String btnText = "Add";
  IconData btnIcon = Icons.add;

  Future<void> handleClick() async {
    if (_nameController.text.isEmpty || _imgController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Items must have a name and an image.")),
      );
      return;
    }

    final imgValid = await Validator.validateImgUrl(_imgController.text);
    if (!imgValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid image URL")));
      return;
    }

    final editingItem = widget.editingItem;

    ItemType item;
    int id = -1;

    if (editingItem == null) {
      item = ItemType(
        id: id,
        name: _nameController.text,
        img: _imgController.text,
        description: _descriptionController.text,
        collection: widget.collectionId,
      );

      id = await DAO.insertItem(item);
    } else {
      id = editingItem.id;
      item = ItemType(
        id: id,
        name: _nameController.text,
        img: _imgController.text,
        description: _descriptionController.text,
        collection: widget.collectionId,
      );

      await DAO.updateItem(item);
    }

    Navigator.pop(
      context,
      ItemType(
        id: id,
        name: item.name,
        description: item.description,
        img: item.img,
        collection: item.collection,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    final item = widget.editingItem;

    if (item != null) {
      _nameController.text = item.name;
      _imgController.text = item.img;
      _descriptionController.text = item.description;

      appBarText = "Edit Item";
      btnText = "Save";
      btnIcon = Icons.check;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarText),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: _imgController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Image",
                ),
              ),
              SizedBox(height: 15),
              FilledButton(
                onPressed: handleClick,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(btnIcon),
                      SizedBox(width: 8),
                      Text(btnText, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back_rounded),
                      SizedBox(width: 8),
                      Text("Cancel", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
