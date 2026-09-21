import 'package:flutter/material.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

class InvoiceCustomerBlock extends StatelessWidget {
  final Bill bill;

  const InvoiceCustomerBlock({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "BILL TO",
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 6),
        Text(
          bill.customerName.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          bill.customerPhone,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}