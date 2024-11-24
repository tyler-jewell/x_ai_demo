import 'package:flutter/material.dart';
import 'package:flutter_app/core/domain/models/item.dart';
import 'package:flutter_app/features/home/presentation/view_models/home_view_model.dart';
import 'package:flutter_app/features/home/presentation/widgets/add_item_dialog.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('MVVM Demo')),
        body: Consumer<HomeViewModel>(
          builder: (_, vm, __) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (vm.error != null) {
              return Center(child: Text('Error: ${vm.error}'));
            }
            return _ItemsList(items: vm.items);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const AddItemDialog(),
          ),
          child: const Icon(Icons.add),
        ),
      );
}

class _ItemsList extends StatelessWidget {
  final List<Item> items;
  const _ItemsList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No items yet'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, i) => ListTile(
        title: Text(items[i].title),
        subtitle: Text(items[i].description),
        trailing: Text(
          items[i].createdAt.toLocal().toString().split('.').first,
        ),
      ),
    );
  }
}
