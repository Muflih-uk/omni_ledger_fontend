import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_state.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/bill_item_row.dart';

class SelectedItemsList extends StatelessWidget {
  final BillingState state;
  final bool showQtyStepper;

  const SelectedItemsList({
    super.key,
    required this.state,
    required this.showQtyStepper,
  });

  @override
  Widget build(BuildContext context) {
    if (state.selectedItems.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppConstants.containerColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.remove_shopping_cart_outlined,
              size: 32,
              color: AppConstants.secondaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              "No items added yet",
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 4),
            Text(
              "Pick items from the list above.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.selectedItems.length,
      itemBuilder: (context, index) {
        final itemData = state.selectedItems[index];
        return BillItemRow(itemData: itemData, showQtyStepper: showQtyStepper);
      },
    );
  }
}