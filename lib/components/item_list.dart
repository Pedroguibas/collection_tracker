import 'package:collection_tracker/types/item_type.dart';
import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final List<ItemType> items;
  final Function(ItemType) openItemPage;

  const ItemList({super.key, required this.items, required this.openItemPage});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, idx) {
        return ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(items[idx].img)),
          title: Text(
            items[idx].name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded),
          onTap: () => openItemPage(items[idx]),
        );
      },
    );
  }
}
