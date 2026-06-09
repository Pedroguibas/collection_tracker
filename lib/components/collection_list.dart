import 'package:collection_tracker/types/collection_type.dart';
import 'package:flutter/material.dart';

class CollectionList extends StatelessWidget {
  final List<CollectionType> collections;
  final Function(CollectionType) openCollectionPage;

  const CollectionList({
    super.key,
    required this.collections,
    required this.openCollectionPage,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: collections.length,
      itemBuilder: (context, idx) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(collections[idx].img),
          ),
          title: Text(collections[idx].name),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          onTap: () => openCollectionPage(collections[idx]),
        );
      },
    );
  }
}
