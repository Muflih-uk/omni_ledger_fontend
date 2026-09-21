import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';

class BillingStepIndicator extends StatelessWidget {
  final int current;

  const BillingStepIndicator({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    const labels = ["Customer", "Items", "Review"];

    return Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 30),
                color: i <= current
                    ? AppConstants.primaryColor
                    : AppConstants.hintColor,
              ),
            ),
          _StepNode(index: i, label: labels[i], active: i <= current),
        ],
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  final int index;
  final String label;
  final bool active;

  const _StepNode({
    required this.index,
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: active ? AppConstants.primaryColor : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: active
                  ? AppConstants.primaryColor
                  : AppConstants.hintColor,
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            "${index + 1}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : AppConstants.secondaryColor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: active
                ? AppConstants.primaryColor
                : AppConstants.secondaryColor,
          ),
        ),
      ],
    );
  }
}