import 'package:flutter/material.dart';
import 'package:omni_ledger/core/util/formatters.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

class InvoiceTotalRow extends StatelessWidget {
  final Bill bill;

  const InvoiceTotalRow({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F4FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "TOTAL  ",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              formatPrice(bill.totalAmount),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}