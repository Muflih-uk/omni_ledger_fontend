import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/services/invoice_pdf_generator.dart';
import 'package:omni_ledger/core/services/share_service.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/invoice_customer_block.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/invoice_header.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/invoice_items_table.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/invoice_total_row.dart';
import 'package:omni_ledger/injection_container.dart';

class InvoicePage extends StatelessWidget {
  final Bill? bill;

  const InvoicePage({super.key, this.bill});

  Future<void> _share(BuildContext context, Bill invoice) async {
    try {
      final bytes = await InvoicePdfGenerator.generate(invoice);
      await ShareService().shareInvoicePdf(bytes, 'invoice_${invoice.id}.pdf');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Could not share invoice"),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoice = bill ?? sl<BillingBloc>().state.createdBill;

    if (invoice == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Invoice not found",
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(gradient: AppConstants.bgGradient),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          actions: [
            IconButton(
              onPressed: () => _share(context, invoice),
              icon: const Icon(Icons.share),
              color: AppConstants.primaryColor,
            ),
          ],
          title: const Text("Invoice"),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(20),
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
                InvoiceHeader(bill: invoice),
                const SizedBox(height: 16),
                const Divider(color: AppConstants.searchBarColor),
                const SizedBox(height: 16),
                InvoiceCustomerBlock(bill: invoice),
                const SizedBox(height: 20),
                const Divider(color: AppConstants.searchBarColor),
                const SizedBox(height: 12),
                InvoiceItemsTable(bill: invoice),
                const SizedBox(height: 16),
                InvoiceTotalRow(bill: invoice),
                const SizedBox(height: 16),
                const Divider(color: AppConstants.searchBarColor),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "Thank you for shopping with us!",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _share(context, invoice),
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text(
                      "Share Invoice",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}