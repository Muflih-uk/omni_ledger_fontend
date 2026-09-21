import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/formatters.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_state.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/edit_item_dialog.dart';

class BillItemRow extends StatelessWidget {
  final Map<String, dynamic> itemData;
  final bool showQtyStepper;

  const BillItemRow({
    super.key,
    required this.itemData,
    required this.showQtyStepper,
  });

  @override
  Widget build(BuildContext context) {
    final itemId = BillingState.asInt(itemData["item_id"]);
    final name = itemData["name"]?.toString() ?? "Item";
    final price = BillingState.asDouble(itemData["price"]);
    final quantity = BillingState.asInt(itemData["quantity"]);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
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
                  "${formatPrice(price)} × $quantity  =  ${formatPrice(price * quantity)}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (showQtyStepper) ...[
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: AppConstants.secondaryColor,
              onPressed: quantity > 1
                  ? () {
                      context.read<BillingBloc>().add(
                        UpdateQuantityEvent(itemId, quantity - 1),
                      );
                    }
                  : null,
            ),
            Text(
              "$quantity",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle),
              color: AppConstants.primaryColor,
              onPressed: () {
                context.read<BillingBloc>().add(
                  UpdateQuantityEvent(itemId, quantity + 1),
                );
              },
            ),
          ] else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppConstants.searchBarColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Qty $quantity",
                style: const TextStyle(
                  color: AppConstants.secondaryColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            color: AppConstants.tertiaryColor,
            onPressed: () => _editItem(context, itemId, name, price),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: AppConstants.dangerColor,
            onPressed: () {
              context.read<BillingBloc>().add(RemoveItemEvent(itemId));
            },
          ),
        ],
      ),
    );
  }

  Future<void> _editItem(
    BuildContext context,
    int itemId,
    String name,
    double price,
  ) async {
    final result = await showEditItemDialog(context, name: name, price: price);

    if (result != null && context.mounted) {
      context.read<BillingBloc>().add(UpdateItemNameEvent(itemId, result.name));
      context.read<BillingBloc>().add(
        UpdateItemPriceEvent(itemId, result.price),
      );
    }
  }
}