import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/inventory/domain/entities/item.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_event.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_state.dart';
import 'package:omni_ledger/features/inventory/presentation/widgets/inventory_empty_state.dart';
import 'package:omni_ledger/features/inventory/presentation/widgets/inventory_error_view.dart';
import 'package:omni_ledger/features/inventory/presentation/widgets/item_card.dart';
import 'package:omni_ledger/injection_container.dart';
import 'package:omni_ledger/shared/ui/app_text_field.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ItemBloc>()..add(FetchItemEvent()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: AppTextField(
              hintText: "Find items",
              prefixIcon: Icon(Icons.search, color: AppConstants.hintColor),
              onChanged: (value) {
                context.read<ItemBloc>().add(SearchItemEvent(value));
              },
            ),
          ),

          Expanded(
            child: BlocConsumer<ItemBloc, ItemState>(
              listener: (context, state) {
                if (state is ItemDeleted) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(content: Text("Item deleted")),
                    );
                }

                if (state is ItemError) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                if (state is ItemLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.primaryColor,
                    ),
                  );
                }

                if (state is ItemLoaded) {
                  return _buildList(context, state.items, state.filterItems,
                      state.deletingIds, state.items.isEmpty);
                }

                if (state is ItemError && state.items != null) {
                  final hasItems = state.items!.isNotEmpty;
                  final filter = state.filterItems ?? state.items!;
                  return _buildList(
                    context,
                    state.items!,
                    filter,
                    const {},
                    hasItems,
                  );
                }

                if (state is ItemError) {
                  return InventoryErrorView(message: state.message);
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<Item> items,
    List<Item> filterItems,
    Set<int> deletingIds,
    bool hasItems,
  ) {
    if (filterItems.isEmpty) {
      return InventoryEmptyState(hasItems: hasItems);
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
      itemCount: filterItems.length,
      itemBuilder: (context, index) {
        final item = filterItems[index];

        return ItemCard(
          item: item,
          isDeleting: deletingIds.contains(item.id),
          onEdit: () {
            context.go(AppConstants.edititemPage, extra: item);
          },
          onDelete: () async {
            final confirmed = await _confirmDelete(context, item);
            if (confirmed && context.mounted) {
              context.read<ItemBloc>().add(DeleteItemEvent(item.id));
            }
          },
        );
      },
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Item item) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Delete Item",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        content: Text(
          "Remove \"${item.name}\" from your inventory?",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              "Cancel",
              style: TextStyle(color: AppConstants.secondaryColor),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              "Delete",
              style: TextStyle(color: AppConstants.dangerColor),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}