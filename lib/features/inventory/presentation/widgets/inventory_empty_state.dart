import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:omni_ledger/core/constants/app_constants.dart';
import 'package:omni_ledger/shared/ui/app_text_button.dart';

class InventoryEmptyState extends StatelessWidget {
  final bool hasItems;

  const InventoryEmptyState({super.key, required this.hasItems});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F4FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasItems ? Icons.search_off : Icons.inventory_2_outlined,
                size: 40,
                color: AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              hasItems ? "No results found" : "Inventory is empty",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              hasItems
                  ? "Try a different search term."
                  : "Start adding your products to the catalog.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (!hasItems) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: AppTextButton(
                  text: "Add Item",
                  onPressed: () {
                    context.go(AppConstants.additemPage);
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}