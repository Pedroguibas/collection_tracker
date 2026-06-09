import 'package:collection_tracker/components/collection_list.dart';
import 'package:collection_tracker/db/DAO.dart';
import 'package:collection_tracker/pages/collection_page.dart';
import 'package:collection_tracker/pages/new_collection_page.dart';
import 'package:collection_tracker/types/collection_type.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  List<CollectionType> _collections = [];

  void addCollection() async {
    final collection = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NewCollectionPage()),
    );
    if (collection != null && collection is CollectionType) {
      _updateCollections();
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CollectionPage(collection: collection),
        ),
      );
      _updateCollections();
    }
  }

  Future<void> openCollectionPage(CollectionType collection) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CollectionPage(collection: collection)),
    );
    _updateCollections();
  }

  Future<void> _updateCollections() async {
    final updatedCollection = await DAO.getAllCollections();
    setState(() {
      _collections = updatedCollection;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collection Tracker"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCollection,
        child: Icon(Icons.add),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 15),
              Text(
                "Collections",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Expanded(
                child: CollectionList(
                  collections: _collections,
                  openCollectionPage: openCollectionPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
