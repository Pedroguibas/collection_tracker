import 'package:collection_tracker/common/validator.dart';
import 'package:collection_tracker/db/DAO.dart';
import 'package:collection_tracker/types/collection_type.dart';
import 'package:flutter/material.dart';

class NewCollectionPage extends StatefulWidget {
  final CollectionType? editingCollection;

  const NewCollectionPage({super.key, this.editingCollection});

  @override
  State<StatefulWidget> createState() {
    return _NewCollectionPageState();
  }
}

class _NewCollectionPageState extends State<NewCollectionPage> {
  var _nameController = TextEditingController();
  var _imgController = TextEditingController();
  String appBarText = "New Collection";
  String btnText = "Add";
  IconData btnIcon = Icons.add;

  @override
  void initState() {
    super.initState();

    final collection = widget.editingCollection;

    if (collection != null) {
      _nameController.text = collection.name;
      _imgController.text = collection.img;
      appBarText = "Edit Collection";
      btnText = "Save";
      btnIcon = Icons.check;
    }
  }

  Future<void> handleClick() async {
    if (_nameController.text.isEmpty || _imgController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Collections must have a name and an image.")),
      );
      return;
    }

    final imgValid = await Validator.validateImgUrl(_imgController.text);
    if (!imgValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid Image Url")));
      return;
    }

    final editingCollection = widget.editingCollection;

    CollectionType collection;
    int id = -1;

    if (editingCollection == null) {
      collection = CollectionType(
        id: id,
        name: _nameController.text,
        img: _imgController.text,
      );

      id = await DAO.insertCollection(collection);
    } else {
      collection = CollectionType(
        id: editingCollection.id,
        name: _nameController.text,
        img: _imgController.text,
      );

      id = editingCollection.id;

      await DAO.updateCollection(collection);
    }

    Navigator.pop(
      context,
      CollectionType(id: id, name: collection.name, img: collection.img),
    );
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
          padding: const EdgeInsets.all(24.0),
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
                    borderRadius: BorderRadius.circular(12),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back),
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
