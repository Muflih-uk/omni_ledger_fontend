import 'package:flutter/material.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';

class BillingSectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;

  const BillingSectionTitle({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.primaryColor, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}