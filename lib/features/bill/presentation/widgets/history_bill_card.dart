import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/formatters.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/history_bloc/history_event.dart';

class HistoryBillCard extends StatelessWidget {
  final Bill bill;
  final bool isToggling;

  const HistoryBillCard({
    super.key,
    required this.bill,
    required this.isToggling,
  });

  bool get _isPaid => bill.paymentStatus == "paid";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 12),
              Expanded(child: _buildCustomerInfo(context)),
              _buildStatusPill(),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: AppConstants.searchBarColor, height: 1),
          const SizedBox(height: 12),
          _buildAmountRow(context),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildViewInvoiceButton(context)),
              const SizedBox(width: 12),
              Expanded(child: _buildToggleButton(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE0F4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.person,
        color: AppConstants.primaryColor,
      ),
    );
  }

  Widget _buildCustomerInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bill.customerName.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${bill.customerPhone}  •  ${_formatDate(bill.createdAt)}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildStatusPill() {
    final color = _isPaid
        ? AppConstants.successColor
        : AppConstants.tertiaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        bill.paymentStatus.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAmountRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "TOTAL AMOUNT",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                formatPrice(bill.totalAmount),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
        ),
        Text(
          "${bill.items.length} item${bill.items.length == 1 ? "" : "s"}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildViewInvoiceButton(BuildContext context) {
    return SizedBox(
      height: 42,
      child: OutlinedButton(
        onPressed: () {
          context.push(AppConstants.invoicePage, extra: bill);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.primaryColor,
          side: const BorderSide(color: AppConstants.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "View Invoice",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    final filled = !_isPaid;
    final color = filled
        ? AppConstants.primaryColor
        : AppConstants.secondaryColor;

    return SizedBox(
      height: 42,
      child: filled
          ? ElevatedButton(
              onPressed: isToggling
                  ? null
                  : () {
                      context
                          .read<HistoryBloc>()
                          .add(ToggleBillStatusEvent(bill.id));
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _toggleChild(filled: filled),
            )
          : OutlinedButton(
              onPressed: isToggling
                  ? null
                  : () {
                      context
                          .read<HistoryBloc>()
                          .add(ToggleBillStatusEvent(bill.id));
                    },
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _toggleChild(filled: filled),
            ),
    );
  }

  Widget _toggleChild({required bool filled}) {
    if (isToggling) {
      return SizedBox(
        height: 18,
        width: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: filled ? Colors.white : AppConstants.secondaryColor,
        ),
      );
    }

    return Text(
      _isPaid ? "Mark Unpaid" : "Mark Paid",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: filled ? Colors.white : AppConstants.secondaryColor,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year;
    return "$d-$m-$y";
  }
}