import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/formatters.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_event.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/quantity_dialog.dart';
import 'package:omni_ledger/features/inventory/domain/entities/item.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_event.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_state.dart';
import 'package:omni_ledger/shared/ui/app_text_field.dart';

class CatalogSection extends StatelessWidget {
  final Set<int> cartItemIds;
  final Map<int, int> cartQuantities;

  const CatalogSection({
    super.key,
    required this.cartItemIds,
    required this.cartQuantities,
  });

  Future<void> _pickItem(
    BuildContext context,
    Item item,
    int existingQty,
  ) async {
    final quantity = await showQuantityDialog(
      context,
      itemName: item.name,
      initial: existingQty,
    );

    if (quantity != null && context.mounted) {
      context.read<BillingBloc>().add(AddItemEvent(item, quantity: quantity));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          hintText: "Search item name",
          prefixIcon: Icon(Icons.search, color: AppConstants.hintColor),
          onChanged: (value) {
            context.read<ItemBloc>().add(SearchItemEvent(value));
          },
        ),
        const SizedBox(height: 10),
        BlocBuilder<ItemBloc, ItemState>(
          builder: (context, state) {
            if (state is ItemLoading) {
              return const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryColor,
                  ),
                ),
              );
            }

            if (state is ItemError) {
              return _ErrorCard(
                message: state.message,
                onRetry: () => context.read<ItemBloc>().add(FetchItemEvent()),
              );
            }

            if (state is ItemLoaded) {
              if (state.filterItems.isEmpty) {
                return _EmptyCatalog(
                  hasItems: state.items.isNotEmpty,
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.filterItems.length,
                itemBuilder: (context, index) {
                  final item = state.filterItems[index];
                  final isAdded = cartItemIds.contains(item.id);
                  final existingQty = cartQuantities[item.id] ?? 1;

                  return _CatalogItemTile(
                    item: item,
                    isAdded: isAdded,
                    quantity: existingQty,
                    onTap: () => _pickItem(context, item, existingQty),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}

class _CatalogItemTile extends StatelessWidget {
  final Item item;
  final bool isAdded;
  final int quantity;
  final VoidCallback onTap;

  const _CatalogItemTile({
    required this.item,
    required this.isAdded,
    required this.quantity,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAdded ? const Color(0xFFE0F4FF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatPrice(item.unitPrice),
                  style: const TextStyle(
                    color: AppConstants.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isAdded
                    ? AppConstants.primaryColor
                    : const Color(0xFFE0F4FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isAdded ? Icons.edit : Icons.add_circle_outline,
                    size: 16,
                    color: isAdded ? Colors.white : AppConstants.primaryColor,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isAdded ? "Qty $quantity" : "Add",
                    style: TextStyle(
                      color: isAdded ? Colors.white : AppConstants.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCatalog extends StatelessWidget {
  final bool hasItems;

  const _EmptyCatalog({required this.hasItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: AppConstants.secondaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            hasItems
                ? "No items match your search"
                : "No items in catalog yet",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppConstants.dangerColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text("Retry", style: Theme.of(context).textTheme.labelMedium),
          ),
        ],
      ),
    );
  }
}