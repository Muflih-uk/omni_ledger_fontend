import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/services/invoice_pdf_generator.dart';
import 'package:omni_ledger/core/services/share_service.dart';
import 'package:omni_ledger/core/util/formatters.dart';
import 'package:omni_ledger/features/bill/domain/entities/bill.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_bloc.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_event.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_state.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/billing_bottom_bar.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/billing_section_title.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/billing_step_indicator.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/catalog_section.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/customer_details_card.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/selected_items_list.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_bloc.dart';
import 'package:omni_ledger/features/inventory/presentation/bloc/item_event.dart';
import 'package:omni_ledger/injection_container.dart';
import 'package:omni_ledger/shared/ui/success_dialog.dart';

class BillingPage extends StatefulWidget {
  const BillingPage({super.key});

  @override
  State<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  static const _maxStep = 2;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _next(int currentStep) {
    if (currentStep == 0 && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (currentStep < _maxStep) {
      context.read<BillingBloc>().add(SetBillingStepEvent(currentStep + 1));
    }
  }

  void _back(int currentStep) {
    if (currentStep > 0) {
      context.read<BillingBloc>().add(SetBillingStepEvent(currentStep - 1));
    }
  }

  void _submit(BillingState state) {
    final formValid = _formKey.currentState?.validate() ?? true;
    if (!formValid) {
      return;
    }
    if (state.selectedItems.isEmpty) {
      return;
    }

    context.read<BillingBloc>().add(
      CreateBillEvent(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      ),
    );
  }

  void _showSuccess(BuildContext listenerContext, Bill bill) {
    nameController.clear();
    phoneController.clear();
    _formKey.currentState?.reset();

    showAppSuccessDialog(
      listenerContext,
      title: "Invoice Created",
      message:
          "Invoice #${bill.id} · ${bill.customerName.toUpperCase()}\n${formatPrice(bill.totalAmount)}",
      actions: [
        SuccessAction(
          label: "View Invoice",
          onTap: () {
            context.push(AppConstants.invoicePage, extra: bill);
          },
        ),
        SuccessAction(label: "Share Invoice", onTap: () => _shareInvoice(bill)),
        const SuccessAction(label: "Done"),
      ],
    );
  }

  Future<void> _shareInvoice(Bill bill) async {
    try {
      final bytes = await InvoicePdfGenerator.generate(bill);
      await ShareService().shareInvoicePdf(bytes, 'invoice_${bill.id}.pdf');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text("Unable to share the invoice")),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: BlocProvider(
            create: (_) => sl<ItemBloc>()..add(FetchItemEvent()),
            child: BlocConsumer<BillingBloc, BillingState>(
              listener: (context, state) {
                if (state.error != null) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(state.error!)));
                }

                if (!state.isLoading && state.createdBill != null) {
                  _showSuccess(context, state.createdBill!);
                }
              },
              builder: (context, state) {
                final step = state.step;
                final cartItemIds = state.selectedItems
                    .map((e) => BillingState.asInt(e["item_id"]))
                    .toSet();
                final cartQuantities = {
                  for (final e in state.selectedItems)
                    BillingState.asInt(e["item_id"]): BillingState.asInt(
                      e["quantity"],
                    ),
                };

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: AppConstants.screenPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              "New Bill",
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Text(
                              "Fill customer details and add items to checkout.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 20),
                            BillingStepIndicator(current: step),
                            const SizedBox(height: 20),
                            if (step == 0) _buildCustomerStep(context),
                            if (step == 1)
                              _buildItemsStep(
                                context,
                                state,
                                cartItemIds,
                                cartQuantities,
                              ),
                            if (step == 2) _buildReviewStep(context, state),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    BillingBottomBar(
                      step: step,
                      state: state,
                      onBack: () => _back(step),
                      onNext: () => _next(step),
                      onSubmit: () => _submit(state),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomerStep(BuildContext context) {
    return CustomerDetailsCard(
      formKey: _formKey,
      nameController: nameController,
      phoneController: phoneController,
    );
  }

  Widget _buildItemsStep(
    BuildContext context,
    BillingState state,
    Set<int> cartItemIds,
    Map<int, int> cartQuantities,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BillingSectionTitle(
          icon: Icons.add_shopping_cart,
          title: "Add Items",
        ),
        const SizedBox(height: 10),
        CatalogSection(
          cartItemIds: cartItemIds,
          cartQuantities: cartQuantities,
        ),
        const SizedBox(height: 22),
        BillingSectionTitle(
          icon: Icons.receipt_long,
          title: "Added to Bill",
          trailing: state.selectedItems.isEmpty
              ? null
              : GestureDetector(
                  onTap: () {
                    context.read<BillingBloc>().add(ClearCartEvent());
                  },
                  child: Text(
                    "Clear all",
                    style: TextStyle(
                      color: AppConstants.dangerColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 10),
        SelectedItemsList(state: state, showQtyStepper: false),
      ],
    );
  }

  Widget _buildReviewStep(BuildContext context, BillingState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BillingSectionTitle(
          icon: Icons.receipt_long,
          title: "Review Items",
        ),
        const SizedBox(height: 10),
        SelectedItemsList(state: state, showQtyStepper: true),
      ],
    );
  }
}