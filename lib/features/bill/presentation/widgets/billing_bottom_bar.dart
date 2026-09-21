import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/core/util/formatters.dart';
import 'package:omni_ledger/features/bill/presentation/bill_bloc/bill_state.dart';
import 'package:omni_ledger/features/bill/presentation/widgets/payment_toggle.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';

class BillingBottomBar extends StatelessWidget {
  final int step;
  final BillingState state;
  final VoidCallback onBack;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const BillingBottomBar({
    super.key,
    required this.step,
    required this.state,
    required this.onBack,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final canNext = !state.isLoading && state.selectedItems.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: switch (step) {
        0 => AppTextButton(onPressed: onNext, text: "Next"),
        1 => Row(
          children: [
            Expanded(
              child: AppTextButton(
                onPressed: onBack,
                text: "Back",
                textColor: AppConstants.containerColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextButton(
                onPressed: canNext ? onNext : () {},
                text: "Next",
              ),
            ),
          ],
        ),
        _ => Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total (${state.itemCount} items)",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatPrice(state.total),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 110,
                  child: AppTextButton(onPressed: onBack, text: "Back"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PaymentToggle(isPaid: state.isPaid),
            const SizedBox(height: 10),
            AppTextButton(
              onPressed: state.isLoading || state.selectedItems.isEmpty
                  ? () {}
                  : onSubmit,
              isLoading: state.isLoading,
              text: state.isLoading ? "Creating Bill" : "Confirm Bill",
            ),
          ],
        ),
      },
    );
  }
}
