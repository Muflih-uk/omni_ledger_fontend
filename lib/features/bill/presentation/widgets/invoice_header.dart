import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';

class InvoiceHeader extends StatelessWidget {
  final Bill bill;

  const InvoiceHeader({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final isPaid = bill.paymentStatus == "paid";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F4FF),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset('assets/logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Omni Ledger",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "Retail Invoice",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Invoice #${bill.id}",
              style: const TextStyle(
                color: AppConstants.primaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(bill.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isPaid
                    ? AppConstants.successColor.withValues(alpha: 0.15)
                    : const Color(0xFFFFB876),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                bill.paymentStatus.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isPaid
                      ? AppConstants.successColor
                      : AppConstants.tertiaryColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return "$d-$m-$y  $h:$min";
  }
}