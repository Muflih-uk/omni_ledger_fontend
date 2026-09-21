import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/formatters.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

class InvoiceItemsTable extends StatelessWidget {
  final Bill bill;

  const InvoiceItemsTable({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _columnHeader(context, "Item", flex: 3),
            _columnHeader(context, "Qty"),
            _columnHeader(context, "Amount", flex: 2),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in bill.items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    item.itemName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${item.quantity}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    formatPrice(item.price),
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppConstants.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _columnHeader(
    BuildContext context,
    String title, {
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}